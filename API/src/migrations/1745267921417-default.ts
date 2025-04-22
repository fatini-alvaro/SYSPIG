import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745267921417 implements MigrationInterface {
    name = 'Default1745267921417'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ADD "data_ultima_cria" TIMESTAMP DEFAULT now()`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "data_ultima_cria"`);
    }

}
