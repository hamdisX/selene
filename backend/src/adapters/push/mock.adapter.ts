import { Logger } from '@nestjs/common';
import { PushService, PushPayload } from '../adapters.module';

export class MockPushAdapter implements PushService {
  private readonly logger = new Logger(MockPushAdapter.name);

  async sendToUser(userId: string, payload: PushPayload): Promise<void> {
    this.logger.log(
      `[PUSH] → user:${userId} | ${payload.title}: ${payload.body}`,
    );
  }

  async sendToTopic(topic: string, payload: PushPayload): Promise<void> {
    this.logger.log(
      `[PUSH] → topic:${topic} | ${payload.title}: ${payload.body}`,
    );
  }

  async registerToken(
    userId: string,
    token: string,
    platform: 'ios' | 'android',
  ): Promise<void> {
    this.logger.log(`[PUSH] Token enregistré user:${userId} platform:${platform} token:${token.slice(0, 10)}…`);
  }
}
