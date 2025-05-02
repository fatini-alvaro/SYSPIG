import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1746127535145 implements MigrationInterface {
    name = 'Default1746127535145'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "venda" ("id" SERIAL NOT NULL, "data_venda" TIMESTAMP NOT NULL DEFAULT now(), "quantidade_vendida" integer, "valor_venda" numeric(10,2), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, "created_by" integer, "updated_by" integer, CONSTRAINT "PK_e54dc36860bef073e9ab638b444" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "venda" ADD CONSTRAINT "FK_a9c19c67151527984e10d300f41" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "venda" ADD CONSTRAINT "FK_5f231945d9cabd073121dffaeb8" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "venda" ADD CONSTRAINT "FK_fe09763f5e6aec94c226df74548" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "venda" DROP CONSTRAINT "FK_fe09763f5e6aec94c226df74548"`);
        await queryRunner.query(`ALTER TABLE "venda" DROP CONSTRAINT "FK_5f231945d9cabd073121dffaeb8"`);
        await queryRunner.query(`ALTER TABLE "venda" DROP CONSTRAINT "FK_a9c19c67151527984e10d300f41"`);
        await queryRunner.query(`DROP TABLE "venda"`);
    }

}
