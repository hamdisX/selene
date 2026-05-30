import { MigrationInterface, QueryRunner } from 'typeorm';

export class RemoveRedundantPhoneIndex1748700001000 implements MigrationInterface {
  name = 'RemoveRedundantPhoneIndex1748700001000';

  async up(queryRunner: QueryRunner): Promise<void> {
    // UQ_users_phone (contrainte UNIQUE) crée déjà un index B-tree sur phone
    // IDX_users_phone est redondant — double le coût des writes sans bénéfice
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_users_phone"`);
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`CREATE INDEX "IDX_users_phone" ON "users" ("phone")`);
  }
}
