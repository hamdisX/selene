import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

// Interfaces
export interface StorageService {
  upload(file: Buffer, key: string, contentType: string): Promise<string>;
  delete(key: string): Promise<void>;
  getPresignedUrl(key: string, expiresIn?: number): Promise<string>;
}

export interface OtpService {
  sendCode(phoneNumber: string): Promise<void>;
  verifyCode(phoneNumber: string, code: string): Promise<boolean>;
}

export interface PushPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
}

export interface PushService {
  sendToUser(userId: string, payload: PushPayload): Promise<void>;
  sendToTopic(topic: string, payload: PushPayload): Promise<void>;
  registerToken(
    userId: string,
    token: string,
    platform: 'ios' | 'android',
  ): Promise<void>;
}

export interface ModerationResult {
  flagged: boolean;
  categories: string[];
  score: number;
}

export interface ModerationService {
  moderateText(content: string): Promise<ModerationResult>;
  moderateImage(imageUrl: string): Promise<ModerationResult>;
}

export interface IsochroneService {
  getIsochrone(
    lat: number,
    lng: number,
    minutes: number,
    mode: 'walk' | 'bike' | 'car',
  ): Promise<object>;
}

// Tokens d'injection
export const STORAGE_SERVICE = 'STORAGE_SERVICE';
export const OTP_SERVICE = 'OTP_SERVICE';
export const PUSH_SERVICE = 'PUSH_SERVICE';
export const MODERATION_SERVICE = 'MODERATION_SERVICE';
export const ISOCHRONE_SERVICE = 'ISOCHRONE_SERVICE';

// Factories dynamiques selon les variables d'environnement
function createStorageProvider() {
  return {
    provide: STORAGE_SERVICE,
    inject: [ConfigService],
    useFactory: async (config: ConfigService): Promise<StorageService> => {
      const driver = config.get<string>('STORAGE_DRIVER');
      if (driver === 'r2') {
        const { CloudflareR2Adapter } = await import('./storage/r2.adapter');
        return new CloudflareR2Adapter(config);
      }
      const { MinIOAdapter } = await import('./storage/minio.adapter');
      return new MinIOAdapter(config);
    },
  };
}

function createOtpProvider() {
  return {
    provide: OTP_SERVICE,
    inject: [ConfigService],
    useFactory: async (config: ConfigService): Promise<OtpService> => {
      const driver = config.get<string>('OTP_DRIVER');
      if (driver === 'twilio') {
        const { TwilioOtpAdapter } = await import('./otp/twilio.adapter');
        return new TwilioOtpAdapter(config);
      }
      const { MockOtpAdapter } = await import('./otp/mock.adapter');
      return new MockOtpAdapter();
    },
  };
}

function createPushProvider() {
  return {
    provide: PUSH_SERVICE,
    inject: [ConfigService],
    useFactory: async (config: ConfigService): Promise<PushService> => {
      const driver = config.get<string>('PUSH_DRIVER');
      if (driver === 'fcm') {
        const { FcmApnsAdapter } = await import('./push/fcm-apns.adapter');
        return new FcmApnsAdapter(config);
      }
      const { MockPushAdapter } = await import('./push/mock.adapter');
      return new MockPushAdapter();
    },
  };
}

function createModerationProvider() {
  return {
    provide: MODERATION_SERVICE,
    inject: [ConfigService],
    useFactory: async (config: ConfigService): Promise<ModerationService> => {
      const driver = config.get<string>('MODERATION_DRIVER');
      if (driver === 'openai') {
        const { OpenAIModerationAdapter } = await import(
          './moderation/openai.adapter'
        );
        return new OpenAIModerationAdapter(config);
      }
      const { MockModerationAdapter } = await import(
        './moderation/mock.adapter'
      );
      return new MockModerationAdapter();
    },
  };
}

function createIsochroneProvider() {
  return {
    provide: ISOCHRONE_SERVICE,
    inject: [ConfigService],
    useFactory: async (config: ConfigService): Promise<IsochroneService> => {
      const driver = config.get<string>('ROUTING_DRIVER');
      if (driver === 'mapbox') {
        const { MapboxIsochroneAdapter } = await import(
          './isochrone/mapbox.adapter'
        );
        return new MapboxIsochroneAdapter(config);
      }
      const { OsrmIsochroneAdapter } = await import(
        './isochrone/osrm.adapter'
      );
      return new OsrmIsochroneAdapter(config);
    },
  };
}

@Global()
@Module({
  providers: [
    createStorageProvider(),
    createOtpProvider(),
    createPushProvider(),
    createModerationProvider(),
    createIsochroneProvider(),
  ],
  exports: [
    STORAGE_SERVICE,
    OTP_SERVICE,
    PUSH_SERVICE,
    MODERATION_SERVICE,
    ISOCHRONE_SERVICE,
  ],
})
export class AdaptersModule {}
