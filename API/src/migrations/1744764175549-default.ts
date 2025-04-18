import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1744764175549 implements MigrationInterface {
    name = 'Default1744764175549'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_2004c7b9803ed6768a46e5b58b1"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "fazenda_id"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "codigo"`);
        await queryRunner.query(`ALTER TABLE "lote" ADD "data_inicio" TIMESTAMP DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "lote" ADD "data_fim" TIMESTAMP DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "lote_animal" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_034d3e697f3bf091aeedc892c8c" FOREIGN KEY ("lote_animal") REFERENCES "lote_animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_034d3e697f3bf091aeedc892c8c"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "lote_animal"`);
        await queryRunner.query(`ALTER TABLE "lote" DROP COLUMN "data_fim"`);
        await queryRunner.query(`ALTER TABLE "lote" DROP COLUMN "data_inicio"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "codigo" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "fazenda_id" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_2004c7b9803ed6768a46e5b58b1" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
