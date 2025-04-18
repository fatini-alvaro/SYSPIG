import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1744844632285 implements MigrationInterface {
    name = 'Default1744844632285'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote" ALTER COLUMN "data_fim" DROP DEFAULT`);
        await queryRunner.query(`ALTER TABLE "lote" ALTER COLUMN "encerrado" SET DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote" ALTER COLUMN "encerrado" SET DEFAULT true`);
        await queryRunner.query(`ALTER TABLE "lote" ALTER COLUMN "data_fim" SET DEFAULT now()`);
    }

}
