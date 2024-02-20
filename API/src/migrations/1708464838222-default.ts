import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1708464838222 implements MigrationInterface {
    name = 'Default1708464838222'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "animal" ("id" SERIAL NOT NULL, "numero_brinco" text NOT NULL, "sexo" text NOT NULL, "status" text NOT NULL, "data_nascimento" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, CONSTRAINT "PK_af42b1374c042fb3fa2251f9f42" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_783bfc695facb3a4c7a83e55cfa" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_783bfc695facb3a4c7a83e55cfa"`);
        await queryRunner.query(`DROP TABLE "animal"`);
    }

}
