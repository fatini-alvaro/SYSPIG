import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1744759372275 implements MigrationInterface {
    name = 'Default1744759372275'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote_animal" ADD "inseminado" boolean NOT NULL DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote_animal" DROP COLUMN "inseminado"`);
    }

}
