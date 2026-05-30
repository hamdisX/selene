import { Logger } from '@nestjs/common';
import { OtpService } from '../adapters.module';

export class MockOtpAdapter implements OtpService {
  private readonly logger = new Logger(MockOtpAdapter.name);
  private readonly codes = new Map<string, string>();

  async sendCode(phoneNumber: string): Promise<void> {
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    this.codes.set(phoneNumber, code);
    this.logger.log(`[OTP SERVICE] Code pour ${phoneNumber} : ${code}`);
  }

  async verifyCode(phoneNumber: string, code: string): Promise<boolean> {
    const stored = this.codes.get(phoneNumber);
    if (stored === code) {
      this.codes.delete(phoneNumber);
      return true;
    }
    return false;
  }
}
