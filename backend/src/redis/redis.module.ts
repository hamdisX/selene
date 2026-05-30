import { Global, Module, OnModuleDestroy, Inject } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Logger } from '@nestjs/common';
import Redis from 'ioredis';

export const REDIS_CLIENT = 'REDIS_CLIENT';

// Fermeture propre à l'arrêt du module (graceful shutdown + tests e2e)
class RedisShutdownService implements OnModuleDestroy {
  private readonly logger = new Logger('RedisModule');
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async onModuleDestroy(): Promise<void> {
    await this.redis.quit();
    this.logger.log('Connexion Redis fermée.');
  }
}

@Global()
@Module({
  providers: [
    {
      provide: REDIS_CLIENT,
      inject: [ConfigService],
      useFactory: (config: ConfigService): Redis => {
        const client = new Redis(config.getOrThrow<string>('REDIS_URL'), {
          maxRetriesPerRequest: 3,
        });
        client.on('error', (err: Error) => {
          new Logger('RedisModule').error(`Erreur Redis : ${err.message}`);
        });
        return client;
      },
    },
    RedisShutdownService,
  ],
  exports: [REDIS_CLIENT],
})
export class RedisModule {}
