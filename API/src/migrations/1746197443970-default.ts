import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1746197443970 implements MigrationInterface {
    name = 'Default1746197443970'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "venda" ADD "peso_venda" numeric(10,2)`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "venda" DROP COLUMN "peso_venda"`);
    }

}
