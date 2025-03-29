import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1743285945570 implements MigrationInterface {
    name = 'Default1743285945570'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_42adf498ae22cc9f479ea5e06ab"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "data_movimentacao"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "tipo_movimentacao"`);
        await queryRunner.query(`DROP TYPE "public"."movimentacao_tipo_movimentacao_enum"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "ocupacao_animal_id"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "observacao"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "dataMovimentacao" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`CREATE TYPE "public"."movimentacao_tipo_enum" AS ENUM('1', '2', '3')`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "tipo" "public"."movimentacao_tipo_enum" NOT NULL`);
        await queryRunner.query(`CREATE TYPE "public"."movimentacao_status_enum" AS ENUM('1', '2')`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "status" "public"."movimentacao_status_enum" NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "observacoes" text`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "observacoes"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "status"`);
        await queryRunner.query(`DROP TYPE "public"."movimentacao_status_enum"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "tipo"`);
        await queryRunner.query(`DROP TYPE "public"."movimentacao_tipo_enum"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "dataMovimentacao"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "observacao" text`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "ocupacao_animal_id" integer`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`CREATE TYPE "public"."movimentacao_tipo_movimentacao_enum" AS ENUM('ENTRADA', 'SAIDA')`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "tipo_movimentacao" "public"."movimentacao_tipo_movimentacao_enum" NOT NULL`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "data_movimentacao" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_42adf498ae22cc9f479ea5e06ab" FOREIGN KEY ("ocupacao_animal_id") REFERENCES "ocupacao_animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
