import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1736532342660 implements MigrationInterface {
    name = 'Default1736532342660'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" ADD "refresh_token" text`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" DROP COLUMN "refresh_token"`);
    }

}
