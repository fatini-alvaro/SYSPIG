import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745255616450 implements MigrationInterface {
    name = 'Default1745255616450'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ADD "lote_animal_atual_id" integer`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "lote_animal_nascimento_id" integer`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_76d33f7195e18fa876c6b8abaee" FOREIGN KEY ("lote_animal_atual_id") REFERENCES "lote_animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_c5e0dd82d837da0f880b326068c" FOREIGN KEY ("lote_animal_nascimento_id") REFERENCES "lote_animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_c5e0dd82d837da0f880b326068c"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_76d33f7195e18fa876c6b8abaee"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "lote_animal_nascimento_id"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "lote_animal_atual_id"`);
    }

}
