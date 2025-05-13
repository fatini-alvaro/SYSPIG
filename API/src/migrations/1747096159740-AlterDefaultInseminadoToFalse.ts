import { MigrationInterface, QueryRunner } from "typeorm";

export class AlterDefaultInseminadoToFalse1747096159740 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE "lote_animal"
            ALTER COLUMN "inseminado" SET DEFAULT false
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE "lote_animal"
            ALTER COLUMN "inseminado" SET DEFAULT true
        `);
    }

}
