import { IsString, IsInt, Min, Max, MinLength, MaxLength, IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class SetupGuestDto {
  @ApiProperty({ example: 'SportiF42', minLength: 2, maxLength: 30 })
  @IsString()
  @MinLength(2)
  @MaxLength(30)
  pseudo!: string;

  @ApiProperty({ example: 25, minimum: 18, maximum: 80 })
  @Type(() => Number)
  @IsInt()
  @Min(18)
  @Max(80)
  age!: number;

  @ApiProperty({ enum: ['homme', 'femme', 'autre'] })
  @IsString()
  @IsIn(['homme', 'femme', 'autre'])
  genre!: string;
}
