import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707657735772 implements MigrationInterface {
    name = 'Default1707657735772'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "uf" ("id" SERIAL NOT NULL, "sigla" text NOT NULL, CONSTRAINT "PK_87b733768cc4578dea660e26bac" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "cidade" ("id" SERIAL NOT NULL, "nome" text NOT NULL, "uf_id" integer, CONSTRAINT "PK_9fefdadd1d47000e7fa6d2abc8c" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD "cidade_id" integer`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD CONSTRAINT "FK_4a92b9a50b2e71eeba18e5567e9" FOREIGN KEY ("uf_id") REFERENCES "uf"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD CONSTRAINT "FK_fbeea8436d3a372a48cf620b9e1" FOREIGN KEY ("cidade_id") REFERENCES "cidade"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "fazenda" DROP CONSTRAINT "FK_fbeea8436d3a372a48cf620b9e1"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP CONSTRAINT "FK_4a92b9a50b2e71eeba18e5567e9"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP COLUMN "cidade_id"`);
        await queryRunner.query(`DROP TABLE "cidade"`);
        await queryRunner.query(`DROP TABLE "uf"`);
    }

}
