import { IsString, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SendOtpDto {
  @ApiProperty({ example: '+33612345678', description: 'Numéro au format E.164 strict' })
  @IsString()
  @Matches(/^\+[1-9]\d{1,14}$/, { message: 'Format E.164 requis (ex : +33612345678)' })
  phone!: string;
}
