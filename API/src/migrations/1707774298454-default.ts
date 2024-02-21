import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707774298454 implements MigrationInterface {
    name = 'Default1707774298454'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "granja" DROP COLUMN "capacidade"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "granja" ADD "capacidade" integer NOT NULL`);
    }

}
