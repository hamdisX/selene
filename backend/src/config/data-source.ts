import 'reflect-metadata';
import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import * as path from 'path';

// En dev, charge .env.local si présent. En staging/prod, les variables viennent de l'environnement système.
if (process.env.NODE_ENV !== 'production' && process.env.NODE_ENV !== 'staging') {
  dotenv.config({ path: path.resolve(process.cwd(), '.env.local'), override: false });
}

if (!process.env.DATABASE_URL) {
  throw new Error('[DataSource] DATABASE_URL requis mais absent — définir dans .env.local (dev) ou les variables système (staging/prod)');
}

export const AppDataSource = new DataSource({
  type: 'postgres',
  url: process.env.DATABASE_URL,
  ssl:
    process.env.NODE_ENV !== 'development'
      ? { rejectUnauthorized: true }
      : false,
  entities: [path.join(__dirname, '..', '**', '*.entity.{ts,js}')],
  migrations: [path.join(__dirname, '..', 'migrations', '*.{ts,js}')],
  synchronize: false,
  migrationsRun: false,
  logging: process.env.NODE_ENV === 'development',
});
