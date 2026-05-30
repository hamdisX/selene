import { Injectable, UnauthorizedException, Inject } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { Redis } from 'ioredis';
import * as fs from 'fs';
import { REDIS_CLIENT } from '../../redis/redis.module';

export interface JwtPayload {
  sub: string;
  phone: string;
  jti: string;
  type: 'access' | 'refresh';
  iat?: number;
  exp?: number;
}

export interface AuthUser {
  userId: string;
  phone: string;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: fs.readFileSync(config.getOrThrow<string>('JWT_PUBLIC_KEY_PATH')),
      algorithms: ['RS256'],
    });
  }

  async validate(payload: JwtPayload): Promise<AuthUser> {
    if (payload.type !== 'access') {
      throw new UnauthorizedException('Type de token invalide');
    }
    const blacklisted = await this.redis.get(`session:blacklist:${payload.jti}`);
    if (blacklisted) {
      throw new UnauthorizedException('Token révoqué');
    }
    return { userId: payload.sub, phone: payload.phone };
  }
}
