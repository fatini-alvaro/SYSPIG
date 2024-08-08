import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711418608582 implements MigrationInterface {
    name = 'Default1711418608582'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" ADD "codigo" integer`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" DROP COLUMN "codigo"`);
    }

}
