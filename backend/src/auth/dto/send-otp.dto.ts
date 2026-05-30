import { IsString, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SendOtpDto {
  @ApiProperty({ example: '+33749414611', description: 'Numéro au format E.164 strict' })
  @IsString()
  @Matches(/^\+[1-9]\d{1,14}$/, { message: 'Format E.164 requis (ex : +33749414611)' })
  phone!: string;
}
