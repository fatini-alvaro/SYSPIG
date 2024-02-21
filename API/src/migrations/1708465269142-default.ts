import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1708465269142 implements MigrationInterface {
    name = 'Default1708465269142'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "anotacao" ("id" SERIAL NOT NULL, "descricao" text NOT NULL, "data" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, "animal_id" integer, CONSTRAINT "PK_28cc47ee158388bdb806948c712" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD CONSTRAINT "FK_6d539c8331ac4ca9ffd595f1731" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD CONSTRAINT "FK_dfc7f25f68c2ecc388bf597088b" FOREIGN KEY ("animal_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" DROP CONSTRAINT "FK_dfc7f25f68c2ecc388bf597088b"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP CONSTRAINT "FK_6d539c8331ac4ca9ffd595f1731"`);
        await queryRunner.query(`DROP TABLE "anotacao"`);
    }

}
