import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745200408490 implements MigrationInterface {
    name = 'Default1745200408490'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ADD "lote_nascimento_id" integer`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_f4a46786e036fd2a0523ed4c4d2" FOREIGN KEY ("lote_nascimento_id") REFERENCES "lote"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_f4a46786e036fd2a0523ed4c4d2"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "lote_nascimento_id"`);
    }

}
