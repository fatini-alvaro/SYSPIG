import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711807445303 implements MigrationInterface {
    name = 'Default1711807445303'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "status" text NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "status"`);
    }

}
