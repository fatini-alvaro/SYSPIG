import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1743285381154 implements MigrationInterface {
    name = 'Default1743285381154'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."movimentacao_tipo_movimentacao_enum" AS ENUM('ENTRADA', 'SAIDA')`);
        await queryRunner.query(`CREATE TABLE "movimentacao" ("id" SERIAL NOT NULL, "data_movimentacao" TIMESTAMP NOT NULL DEFAULT now(), "tipo_movimentacao" "public"."movimentacao_tipo_movimentacao_enum" NOT NULL, "observacao" text, "created_at" TIMESTAMP NOT NULL DEFAULT now(), "ocupacao_animal_id" integer, "animal_id" integer, "baia_origem_id" integer, "baia_destino_id" integer, "usuario_id" integer, CONSTRAINT "PK_623863f0070f0cf47efcc0fb7c7" PRIMARY KEY ("id")); COMMENT ON COLUMN "movimentacao"."tipo_movimentacao" IS 'Tipo de movimentação (ENTRADA ou SAIDA)'`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_42adf498ae22cc9f479ea5e06ab" FOREIGN KEY ("ocupacao_animal_id") REFERENCES "ocupacao_animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_84b322b608aeb17ae846306c4c4" FOREIGN KEY ("animal_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_cbee6566b0b2397b88819ff043d" FOREIGN KEY ("baia_origem_id") REFERENCES "baia"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_a1b01e899ae1d91e6be7e65cbdd" FOREIGN KEY ("baia_destino_id") REFERENCES "baia"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_09064cdad1f9986212e3a9f95bf" FOREIGN KEY ("usuario_id") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_09064cdad1f9986212e3a9f95bf"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_a1b01e899ae1d91e6be7e65cbdd"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_cbee6566b0b2397b88819ff043d"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_84b322b608aeb17ae846306c4c4"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_42adf498ae22cc9f479ea5e06ab"`);
        await queryRunner.query(`DROP TABLE "movimentacao"`);
        await queryRunner.query(`DROP TYPE "public"."movimentacao_tipo_movimentacao_enum"`);
    }

}
