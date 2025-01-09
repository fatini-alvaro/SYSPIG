import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1736272617796 implements MigrationInterface {
    name = 'Default1736272617796'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "status"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "status" integer NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "status"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "status" text NOT NULL`);
    }

}
