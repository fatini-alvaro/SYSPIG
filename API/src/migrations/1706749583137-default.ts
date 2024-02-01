import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1706749583137 implements MigrationInterface {
    name = 'Default1706749583137'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "usuario" ("id" SERIAL NOT NULL, "nome" text NOT NULL, "tipo_usuario_id" integer, CONSTRAINT "PK_a56c58e5cabaa04fb2c98d2d7e2" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "tipo_usuario" ("id" SERIAL NOT NULL, "descricao" text NOT NULL, CONSTRAINT "PK_2abd2759a18236cbf357c06dea0" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "fazenda" ("id" SERIAL NOT NULL, "nome" text NOT NULL, CONSTRAINT "PK_0528993051033f09ce373a4b809" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "usuario" ADD CONSTRAINT "FK_eb2c4aa5ed543b544475678b409" FOREIGN KEY ("tipo_usuario_id") REFERENCES "tipo_usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" DROP CONSTRAINT "FK_eb2c4aa5ed543b544475678b409"`);
        await queryRunner.query(`DROP TABLE "fazenda"`);
        await queryRunner.query(`DROP TABLE "tipo_usuario"`);
        await queryRunner.query(`DROP TABLE "usuario"`);
    }

}
