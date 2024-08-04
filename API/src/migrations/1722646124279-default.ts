import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722646124279 implements MigrationInterface {
    name = 'Default1722646124279'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "lote" ("id" SERIAL NOT NULL, "descricao" text NOT NULL, "numero_lote" text, "data" TIMESTAMP NOT NULL DEFAULT now(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, "created_by" integer, "updated_by" integer, CONSTRAINT "PK_db72652dca29e9e818c3c10abed" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "lote" ADD CONSTRAINT "FK_996eb86f482619e19586e2944fc" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lote" ADD CONSTRAINT "FK_6c0bf1a07a822e5da9553f74e7a" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lote" ADD CONSTRAINT "FK_41348b4df7e59d9f054b251defc" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote" DROP CONSTRAINT "FK_41348b4df7e59d9f054b251defc"`);
        await queryRunner.query(`ALTER TABLE "lote" DROP CONSTRAINT "FK_6c0bf1a07a822e5da9553f74e7a"`);
        await queryRunner.query(`ALTER TABLE "lote" DROP CONSTRAINT "FK_996eb86f482619e19586e2944fc"`);
        await queryRunner.query(`DROP TABLE "lote"`);
    }

}
