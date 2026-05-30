import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AuthService, TokenPair } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { SendOtpDto } from './dto/send-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { SetupGuestDto } from './dto/setup-guest.dto';
import { LogoutDto } from './dto/logout.dto';

interface RequestWithUser extends Request {
  user: { userId: string; phone: string };
}

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('phone')
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 3, ttl: 600000 } })
  @ApiOperation({ summary: 'Envoyer un code OTP par SMS' })
  @ApiResponse({ status: 204, description: 'OTP envoyé' })
  @ApiResponse({ status: 429, description: 'Trop de requêtes' })
  async sendOtp(@Body() dto: SendOtpDto): Promise<void> {
    await this.authService.sendOtp(dto.phone);
  }

  @Post('verify')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({ summary: 'Vérifier le code OTP et obtenir les tokens JWT' })
  @ApiResponse({ status: 200, description: 'Tokens JWT émis' })
  @ApiResponse({ status: 401, description: 'Code invalide' })
  async verifyOtp(
    @Body() dto: VerifyOtpDto,
  ): Promise<TokenPair & { is_new_user: boolean }> {
    return this.authService.verifyOtp(dto.phone, dto.code);
  }

  @Post('guest')
  @HttpCode(HttpStatus.NO_CONTENT)
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Configurer le profil invité (pseudo, âge, genre)' })
  @ApiResponse({ status: 204, description: 'Profil configuré' })
  @ApiResponse({ status: 409, description: 'Pseudo déjà pris' })
  async setupGuest(
    @Request() req: RequestWithUser,
    @Body() dto: SetupGuestDto,
  ): Promise<void> {
    await this.authService.setupGuest(req.user.userId, dto);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Renouveler les tokens JWT' })
  @ApiResponse({ status: 200, description: 'Nouveaux tokens JWT' })
  async refresh(@Body() dto: RefreshTokenDto): Promise<TokenPair> {
    return this.authService.refresh(dto.refresh_token);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Déconnexion — blacklister le refresh token' })
  @ApiResponse({ status: 204, description: 'Déconnecté' })
  async logout(@Body() dto: LogoutDto): Promise<void> {
    await this.authService.logout(dto.refresh_token);
  }
}
