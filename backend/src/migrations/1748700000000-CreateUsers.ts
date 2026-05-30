import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateUsers1748700000000 implements MigrationInterface {
  name = 'CreateUsers1748700000000';

  async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "users" (
        "id"                  UUID         DEFAULT gen_random_uuid() NOT NULL,
        "phone"               VARCHAR(20)  NOT NULL,
        "pseudo"              VARCHAR(30),
        "age"                 SMALLINT,
        "genre"               VARCHAR(10)
          CONSTRAINT "CHK_users_genre" CHECK ("genre" IN ('homme', 'femme', 'autre')),
        "photo_url"           TEXT,
        "trust_score"         SMALLINT     NOT NULL DEFAULT 0,
        "is_profile_complete" BOOLEAN      NOT NULL DEFAULT false,
        "created_at"          TIMESTAMPTZ  NOT NULL DEFAULT now(),
        "updated_at"          TIMESTAMPTZ  NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_users_phone"  UNIQUE ("phone"),
        CONSTRAINT "UQ_users_pseudo" UNIQUE ("pseudo"),
        CONSTRAINT "PK_users"        PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE INDEX "IDX_users_phone" ON "users" ("phone")
    `);

    await queryRunner.query(`
      CREATE TABLE "push_tokens" (
        "id"         UUID         DEFAULT gen_random_uuid() NOT NULL,
        "user_id"    UUID         NOT NULL,
        "token"      VARCHAR(255) NOT NULL,
        "platform"   VARCHAR(10)  NOT NULL
          CONSTRAINT "CHK_push_tokens_platform" CHECK ("platform" IN ('ios', 'android')),
        "created_at" TIMESTAMPTZ  NOT NULL DEFAULT now(),
        CONSTRAINT "PK_push_tokens"   PRIMARY KEY ("id"),
        CONSTRAINT "FK_push_tokens_user" FOREIGN KEY ("user_id")
          REFERENCES "users"("id") ON DELETE CASCADE
      )
    `);

    await queryRunner.query(`
      CREATE INDEX "IDX_push_tokens_user_id" ON "push_tokens" ("user_id")
    `);
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_push_tokens_user_id"`);
    await queryRunner.query(`DROP TABLE IF EXISTS "push_tokens"`);
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_users_phone"`);
    await queryRunner.query(`DROP TABLE IF EXISTS "users"`);
  }
}
