import {
  Injectable,
  Inject,
  UnauthorizedException,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Redis } from 'ioredis';
import { randomUUID } from 'crypto';
import { UsersService } from '../users/users.service';
import { OtpService, OTP_SERVICE } from '../adapters/adapters.module';
import { REDIS_CLIENT } from '../redis/redis.module';
import { Genre } from '../users/entities/user.entity';
import { JwtPayload } from './strategies/jwt.strategy';
import { SetupGuestDto } from './dto/setup-guest.dto';

// Contraintes de sécurité OTP (voir TECHNICAL_DECISIONS.md §2.7)
const OTP_RATE_LIMIT_TTL = 10 * 60;
const OTP_RATE_LIMIT_MAX = 3;
const OTP_ATTEMPTS_MAX = 3;
const OTP_LOCKOUT_TTL = 15 * 60;

export interface TokenPair {
  access_token: string;
  refresh_token: string;
}

@Injectable()
export class AuthService {
  private readonly accessExpiresIn: number;
  private readonly refreshExpiresIn: number;

  constructor(
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
    private readonly usersService: UsersService,
    @Inject(OTP_SERVICE) private readonly otpService: OtpService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {
    this.accessExpiresIn = this.config.getOrThrow<number>('JWT_ACCESS_EXPIRES_IN');
    this.refreshExpiresIn = this.config.getOrThrow<number>('JWT_REFRESH_EXPIRES_IN');
  }

  async sendOtp(phone: string): Promise<void> {
    const locked = await this.redis.get(`otp:lockout:${phone}`);
    if (locked) {
      throw new HttpException('Trop de tentatives. Réessayez dans 15 minutes.', HttpStatus.TOO_MANY_REQUESTS);
    }

    const rateKey = `otp:ratelimit:${phone}`;
    const sends = await this.redis.incr(rateKey);
    if (sends === 1) await this.redis.expire(rateKey, OTP_RATE_LIMIT_TTL);
    if (sends > OTP_RATE_LIMIT_MAX) {
      throw new HttpException('Trop de codes envoyés. Réessayez dans 10 minutes.', HttpStatus.TOO_MANY_REQUESTS);
    }

    await this.otpService.sendCode(phone);
    await this.redis.del(`otp:attempts:${phone}`);
  }

  async verifyOtp(
    phone: string,
    code: string,
  ): Promise<TokenPair & { is_new_user: boolean }> {
    const locked = await this.redis.get(`otp:lockout:${phone}`);
    if (locked) {
      throw new HttpException('Compte temporairement bloqué. Réessayez dans 15 minutes.', HttpStatus.TOO_MANY_REQUESTS);
    }

    const valid = await this.otpService.verifyCode(phone, code);

    if (!valid) {
      const attemptsKey = `otp:attempts:${phone}`;
      const attempts = await this.redis.incr(attemptsKey);
      if (attempts === 1) await this.redis.expire(attemptsKey, OTP_RATE_LIMIT_TTL);
      if (attempts >= OTP_ATTEMPTS_MAX) {
        await this.redis.setex(`otp:lockout:${phone}`, OTP_LOCKOUT_TTL, '1');
        await this.redis.del(attemptsKey);
        throw new HttpException('Trop de tentatives. Compte bloqué 15 minutes.', HttpStatus.TOO_MANY_REQUESTS);
      }
      throw new UnauthorizedException('Code invalide ou expiré.');
    }

    await this.redis.del(`otp:attempts:${phone}`);

    let user = await this.usersService.findByPhone(phone);
    const isNewUser = !user;
    if (!user) user = await this.usersService.createFromPhone(phone);

    return { ...this.issueTokens(user.id, user.phone), is_new_user: isNewUser };
  }

  async setupGuest(userId: string, dto: SetupGuestDto): Promise<void> {
    await this.usersService.updateGuestProfile(
      userId,
      dto.pseudo,
      dto.age,
      dto.genre as Genre,
    );
  }

  async refresh(refreshToken: string): Promise<TokenPair> {
    let payload: JwtPayload;
    try {
      payload = await this.jwtService.verifyAsync<JwtPayload>(refreshToken);
    } catch {
      throw new UnauthorizedException('Token invalide ou expiré.');
    }

    if (payload.type !== 'refresh') {
      throw new UnauthorizedException('Type de token invalide.');
    }

    const blacklisted = await this.redis.get(`session:blacklist:${payload.jti}`);
    if (blacklisted) {
      throw new UnauthorizedException('Token révoqué.');
    }

    const user = await this.usersService.findById(payload.sub);
    if (!user) throw new UnauthorizedException('Utilisateur introuvable.');

    // Blacklister l'ancien refresh token pour la durée restante
    const now = Math.floor(Date.now() / 1000);
    const ttl = (payload.exp ?? 0) - now;
    if (ttl > 0) {
      await this.redis.setex(`session:blacklist:${payload.jti}`, ttl, '1');
    }

    return this.issueTokens(user.id, user.phone);
  }

  async logout(refreshToken: string): Promise<void> {
    let payload: JwtPayload;
    try {
      payload = await this.jwtService.verifyAsync<JwtPayload>(refreshToken);
    } catch {
      // Token déjà expiré ou invalide — déconnexion locale suffisante
      return;
    }

    const now = Math.floor(Date.now() / 1000);
    const ttl = (payload.exp ?? 0) - now;
    if (ttl > 0) {
      await this.redis.setex(`session:blacklist:${payload.jti}`, ttl, '1');
    }
  }

  private issueTokens(userId: string, phone: string): TokenPair {
    const accessJti = randomUUID();
    const refreshJti = randomUUID();

    const access_token = this.jwtService.sign(
      { sub: userId, phone, jti: accessJti, type: 'access' },
      { expiresIn: this.accessExpiresIn },
    );

    const refresh_token = this.jwtService.sign(
      { sub: userId, phone, jti: refreshJti, type: 'refresh' },
      { expiresIn: this.refreshExpiresIn },
    );

    return { access_token, refresh_token };
  }
}
