import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs';
import { UsersModule } from '../users/users.module';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const privatePath = config.getOrThrow<string>('JWT_PRIVATE_KEY_PATH');
        const publicPath = config.getOrThrow<string>('JWT_PUBLIC_KEY_PATH');

        if (!fs.existsSync(privatePath)) {
          throw new Error(
            `AuthModule: clé privée JWT introuvable : ${privatePath}. Générer les clés avec scripts/generate-jwt-keys.sh`,
          );
        }
        if (!fs.existsSync(publicPath)) {
          throw new Error(
            `AuthModule: clé publique JWT introuvable : ${publicPath}. Générer les clés avec scripts/generate-jwt-keys.sh`,
          );
        }

        return {
          privateKey: fs.readFileSync(privatePath),
          publicKey: fs.readFileSync(publicPath),
          signOptions: {
            algorithm: 'RS256',
            expiresIn: config.getOrThrow<number>('JWT_ACCESS_EXPIRES_IN'),
          },
          verifyOptions: {
            algorithms: ['RS256'],
          },
        };
      },
    }),
    UsersModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, JwtAuthGuard],
  exports: [JwtModule, PassportModule, JwtAuthGuard],
})
export class AuthModule {}
