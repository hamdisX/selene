import { ConfigService } from '@nestjs/config';
import { PushService, PushPayload } from '../adapters.module';

export class FcmApnsAdapter implements PushService {
  constructor(private readonly config: ConfigService) {}

  async sendToUser(userId: string, payload: PushPayload): Promise<void> {
    void userId;
    void payload;
    throw new Error('FCM/APNs adapter — implémenter avec firebase-admin');
  }

  async sendToTopic(topic: string, payload: PushPayload): Promise<void> {
    void topic;
    void payload;
    throw new Error('FCM/APNs adapter — implémenter avec firebase-admin');
  }

  async registerToken(
    userId: string,
    token: string,
    platform: 'ios' | 'android',
  ): Promise<void> {
    void userId;
    void token;
    void platform;
    throw new Error('FCM/APNs adapter — implémenter avec firebase-admin');
  }
}
