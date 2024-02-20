import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1708465644271 implements MigrationInterface {
    name = 'Default1708465644271'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "baia" ("id" SERIAL NOT NULL, "numero" text NOT NULL, "capacidade" integer NOT NULL, "vazia" boolean NOT NULL DEFAULT true, "fazenda_id" integer, "granja_id" integer, CONSTRAINT "PK_7fee637a87c01e8981ddefc9759" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "baia" ADD CONSTRAINT "FK_6699e907564d1f570423dad650f" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "baia" ADD CONSTRAINT "FK_baf0d048608ead34cfe0e9b4d90" FOREIGN KEY ("granja_id") REFERENCES "granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" DROP CONSTRAINT "FK_baf0d048608ead34cfe0e9b4d90"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP CONSTRAINT "FK_6699e907564d1f570423dad650f"`);
        await queryRunner.query(`DROP TABLE "baia"`);
    }

}
