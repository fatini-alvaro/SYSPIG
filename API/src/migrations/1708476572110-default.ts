import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1708476572110 implements MigrationInterface {
    name = 'Default1708476572110'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "inseminacao" ("id" SERIAL NOT NULL, "data" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, "porco_doador_id" integer, "porca_inseminada_id" integer, CONSTRAINT "PK_62de02be045f21389258be269d3" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_2004c7b9803ed6768a46e5b58b1" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_c343f1aa332ab055b827a0cae9e" FOREIGN KEY ("porco_doador_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_b51226b5d24789a25a8807e78c2" FOREIGN KEY ("porca_inseminada_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_b51226b5d24789a25a8807e78c2"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_c343f1aa332ab055b827a0cae9e"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_2004c7b9803ed6768a46e5b58b1"`);
        await queryRunner.query(`DROP TABLE "inseminacao"`);
    }

}
