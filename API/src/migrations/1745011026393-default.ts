import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745011026393 implements MigrationInterface {
    name = 'Default1745011026393'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "fazenda_id" integer`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_3f5d8d243f6c742d0fb8dbf64af" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_3f5d8d243f6c742d0fb8dbf64af"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "fazenda_id"`);
    }

}
