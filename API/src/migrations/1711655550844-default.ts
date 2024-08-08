import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711655550844 implements MigrationInterface {
    name = 'Default1711655550844'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ADD "codigo" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "codigo" integer`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "codigo"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "codigo"`);
    }

}
