import { Logger } from '@nestjs/common';
import { ModerationService, ModerationResult } from '../adapters.module';

export class MockModerationAdapter implements ModerationService {
  private readonly logger = new Logger(MockModerationAdapter.name);

  async moderateText(content: string): Promise<ModerationResult> {
    this.logger.debug(`[MODERATION] Texte accepté (mock): ${content.slice(0, 50)}`);
    return { flagged: false, categories: [], score: 0 };
  }

  async moderateImage(imageUrl: string): Promise<ModerationResult> {
    this.logger.debug(`[MODERATION] Image acceptée (mock): ${imageUrl}`);
    return { flagged: false, categories: [], score: 0 };
  }
}
