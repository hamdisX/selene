import { ConfigService } from '@nestjs/config';
import { ModerationService, ModerationResult } from '../adapters.module';

export class OpenAIModerationAdapter implements ModerationService {
  constructor(private readonly config: ConfigService) {}

  async moderateText(content: string): Promise<ModerationResult> {
    void content;
    throw new Error('OpenAI Moderation adapter — implémenter avec openai SDK');
  }

  async moderateImage(imageUrl: string): Promise<ModerationResult> {
    void imageUrl;
    throw new Error('OpenAI Moderation adapter — implémenter avec openai SDK');
  }
}
