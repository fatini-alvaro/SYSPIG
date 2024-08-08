import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711762237007 implements MigrationInterface {
    name = 'Default1711762237007'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "createdAt"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "updatedAt"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "updatedAt" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "createdAt" TIMESTAMP NOT NULL DEFAULT now()`);
    }

}
