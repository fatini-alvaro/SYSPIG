import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711759801104 implements MigrationInterface {
    name = 'Default1711759801104'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "ocupacao" ("id" SERIAL NOT NULL, "codigo" integer, "data_abertura" TIMESTAMP DEFAULT now(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, "granja_id" integer, "animal_id" integer, "baia_id" integer, "created_by" integer, "updated_by" integer, CONSTRAINT "PK_b1c7e62c6a42dc0fd41c516c892" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_51ba83013ff01030112df9fd68d" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_4e6af249a883f65bae6c997a930" FOREIGN KEY ("granja_id") REFERENCES "granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_9aedb48531cbe82ed0cd0e16de9" FOREIGN KEY ("animal_id") REFERENCES "granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_ae3dc2080f6b5a154ed71a21fd1" FOREIGN KEY ("baia_id") REFERENCES "ocupacao"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_e6a33d603f5cae83d20a39fb9a2" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_03274bef7dda406f74887a0bea6" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_03274bef7dda406f74887a0bea6"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_e6a33d603f5cae83d20a39fb9a2"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_ae3dc2080f6b5a154ed71a21fd1"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_9aedb48531cbe82ed0cd0e16de9"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_4e6af249a883f65bae6c997a930"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_51ba83013ff01030112df9fd68d"`);
        await queryRunner.query(`DROP TABLE "ocupacao"`);
    }

}
