import { IsString, Length, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyOtpDto {
  @ApiProperty({ example: '+33612345678' })
  @IsString()
  @Matches(/^\+[1-9]\d{1,14}$/, { message: 'Format E.164 requis (ex : +33612345678)' })
  phone!: string;

  @ApiProperty({ example: '847291', description: 'Code OTP à 6 chiffres' })
  @IsString()
  @Length(6, 6)
  @Matches(/^\d{6}$/, { message: 'Le code OTP doit contenir exactement 6 chiffres' })
  code!: string;
}
