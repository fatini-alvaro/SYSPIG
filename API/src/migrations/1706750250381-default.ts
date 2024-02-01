import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1706750250381 implements MigrationInterface {
    name = 'Default1706750250381'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" ADD "email" text NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" DROP COLUMN "email"`);
    }

}
