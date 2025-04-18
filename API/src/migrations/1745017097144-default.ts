import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745017097144 implements MigrationInterface {
    name = 'Default1745017097144'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ADD "data_ultima_inseminacao" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "lote_atual_id" integer`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_89d178c3d457d0d7de39ba53724" FOREIGN KEY ("lote_atual_id") REFERENCES "lote"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_89d178c3d457d0d7de39ba53724"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "lote_atual_id"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "data_ultima_inseminacao"`);
    }

}
