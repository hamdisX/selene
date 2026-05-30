import { z } from 'zod';

const envSchema = z
  .object({
    // Application
    NODE_ENV: z.enum(['development', 'staging', 'production']),
    PORT: z.coerce.number().default(3000),

    // PostgreSQL
    DATABASE_URL: z.string().url(),
    DB_PASSWORD: z.string().min(16),

    // Redis
    REDIS_URL: z.string().url(),
    REDIS_PASSWORD: z.string().min(16),

    // JWT (RS256 — fichiers PEM)
    JWT_PRIVATE_KEY_PATH: z.string().min(1),
    JWT_PUBLIC_KEY_PATH: z.string().min(1),
    JWT_ACCESS_EXPIRES_IN: z.coerce.number().positive().default(900),
    JWT_REFRESH_EXPIRES_IN: z.coerce.number().positive().default(604800),

    // Drivers (Pattern Adapter)
    STORAGE_DRIVER: z.enum(['minio', 'r2']),
    MAP_DRIVER: z.enum(['maplibre', 'mapbox']),
    OTP_DRIVER: z.enum(['mock', 'twilio']),
    PUSH_DRIVER: z.enum(['mock', 'fcm']),
    MODERATION_DRIVER: z.enum(['mock', 'openai']),
    ROUTING_DRIVER: z.enum(['osrm', 'mapbox']),

    // MinIO (dev)
    MINIO_ENDPOINT: z.string().optional(),
    MINIO_PORT: z.coerce.number().optional(),
    MINIO_ACCESS_KEY: z.string().optional(),
    MINIO_SECRET_KEY: z.string().optional(),
    MINIO_BUCKET: z.string().optional(),

    // Cloudflare R2 (prod)
    R2_ACCOUNT_ID: z.string().optional(),
    R2_ACCESS_KEY_ID: z.string().optional(),
    R2_SECRET_ACCESS_KEY: z.string().optional(),
    R2_BUCKET: z.string().optional(),
    R2_PUBLIC_DOMAIN: z.string().optional(),

    // Mapbox
    MAPBOX_TOKEN: z.string().optional(),

    // OSRM (dev)
    OSRM_URL: z.string().url().optional(),

    // Twilio (staging/prod)
    TWILIO_ACCOUNT_SID: z.string().optional(),
    TWILIO_AUTH_TOKEN: z.string().optional(),
    TWILIO_PHONE_NUMBER: z.string().optional(),

    // FCM (Android)
    FCM_PROJECT_ID: z.string().optional(),
    FCM_PRIVATE_KEY: z.string().optional(),
    FCM_CLIENT_EMAIL: z.string().optional(),

    // APNs (iOS)
    APNS_KEY_ID: z.string().optional(),
    APNS_TEAM_ID: z.string().optional(),
    APNS_PRIVATE_KEY_PATH: z.string().optional(),

    // OpenAI (modération prod)
    OPENAI_API_KEY: z.string().optional(),
    OPENAI_ORG_ID: z.string().optional(),
  })
  // OTP_DRIVER=mock interdit hors développement
  .refine(
    (env) => !(env.OTP_DRIVER === 'mock' && env.NODE_ENV !== 'development'),
    { message: 'OTP_DRIVER=mock est interdit en staging et production' },
  )
  // Twilio requis si OTP_DRIVER=twilio
  .refine(
    (env) =>
      !(
        env.OTP_DRIVER === 'twilio' &&
        (!env.TWILIO_ACCOUNT_SID || !env.TWILIO_AUTH_TOKEN)
      ),
    {
      message:
        'TWILIO_ACCOUNT_SID et TWILIO_AUTH_TOKEN requis si OTP_DRIVER=twilio',
    },
  )
  // Mapbox token requis si MAP_DRIVER ou ROUTING_DRIVER = mapbox
  .refine(
    (env) =>
      !(
        (env.MAP_DRIVER === 'mapbox' || env.ROUTING_DRIVER === 'mapbox') &&
        !env.MAPBOX_TOKEN
      ),
    {
      message:
        'MAPBOX_TOKEN requis si MAP_DRIVER=mapbox ou ROUTING_DRIVER=mapbox',
    },
  )
  // FCM requis si PUSH_DRIVER=fcm
  .refine(
    (env) => !(env.PUSH_DRIVER === 'fcm' && !env.FCM_PROJECT_ID),
    { message: 'FCM_PROJECT_ID requis si PUSH_DRIVER=fcm' },
  )
  // OpenAI requis si MODERATION_DRIVER=openai
  .refine(
    (env) =>
      !(env.MODERATION_DRIVER === 'openai' && !env.OPENAI_API_KEY),
    { message: 'OPENAI_API_KEY requis si MODERATION_DRIVER=openai' },
  );

export type Env = z.infer<typeof envSchema>;

export function validateEnv(config: Record<string, unknown>): Env {
  const result = envSchema.safeParse(config);
  if (!result.success) {
    const errors = result.error.errors
      .map((e) => `  ${e.path.join('.')}: ${e.message}`)
      .join('\n');
    throw new Error(
      `Validation des variables d'environnement échouée :\n${errors}`,
    );
  }
  return result.data;
}
