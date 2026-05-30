import { ConfigService } from '@nestjs/config';
import { OtpService } from '../adapters.module';

export class TwilioOtpAdapter implements OtpService {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  private client: any;
  private readonly fromNumber: string;

  constructor(private readonly config: ConfigService) {
    this.fromNumber = config.getOrThrow<string>('TWILIO_PHONE_NUMBER');
  }

  private async getClient() {
    if (!this.client) {
      const twilio = await import('twilio');
      this.client = twilio.default(
        this.config.getOrThrow<string>('TWILIO_ACCOUNT_SID'),
        this.config.getOrThrow<string>('TWILIO_AUTH_TOKEN'),
      );
    }
    return this.client;
  }

  async sendCode(phoneNumber: string): Promise<void> {
    const client = await this.getClient();
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    await client.messages.create({
      body: `Votre code Séléné : ${code}`,
      from: this.fromNumber,
      to: phoneNumber,
    });
  }

  async verifyCode(_phoneNumber: string, _code: string): Promise<boolean> {
    throw new Error('Twilio OTP verification doit être implémenté avec Redis');
  }
}
