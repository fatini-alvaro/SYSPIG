import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1743028378415 implements MigrationInterface {
    name = 'Default1743028378415'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD "data_entrada" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD "data_saida" TIMESTAMP`);
        await queryRunner.query(`CREATE TYPE "public"."ocupacao_animal_status_enum" AS ENUM('1', '2')`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD "status" "public"."ocupacao_animal_status_enum" NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP CONSTRAINT "FK_372dd5fdcb3c52b90e9a60d036f"`);
        await queryRunner.query(`ALTER TABLE "usuario" DROP CONSTRAINT "FK_eb2c4aa5ed543b544475678b409"`);
        await queryRunner.query(`ALTER TABLE "tipo_usuario" ALTER COLUMN "id" DROP DEFAULT`);
        await queryRunner.query(`DROP SEQUENCE "tipo_usuario_id_seq"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "status"`);
        await queryRunner.query(`CREATE TYPE "public"."animal_status_enum" AS ENUM('1', '2', '3')`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "status" "public"."animal_status_enum" NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE "granja" DROP CONSTRAINT "FK_020becf4951f35bf23161a8968c"`);
        await queryRunner.query(`ALTER TABLE "tipo_granja" ALTER COLUMN "id" DROP DEFAULT`);
        await queryRunner.query(`DROP SEQUENCE "tipo_granja_id_seq"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "status"`);
        await queryRunner.query(`CREATE TYPE "public"."ocupacao_status_enum" AS ENUM('1', '2')`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "status" "public"."ocupacao_status_enum" NOT NULL DEFAULT '1'`);
        await queryRunner.query(`ALTER TABLE "usuario" ADD CONSTRAINT "FK_eb2c4aa5ed543b544475678b409" FOREIGN KEY ("tipo_usuario_id") REFERENCES "tipo_usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD CONSTRAINT "FK_372dd5fdcb3c52b90e9a60d036f" FOREIGN KEY ("tipo_usuario_id") REFERENCES "tipo_usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "granja" ADD CONSTRAINT "FK_020becf4951f35bf23161a8968c" FOREIGN KEY ("tipo_granja_id") REFERENCES "tipo_granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "granja" DROP CONSTRAINT "FK_020becf4951f35bf23161a8968c"`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP CONSTRAINT "FK_372dd5fdcb3c52b90e9a60d036f"`);
        await queryRunner.query(`ALTER TABLE "usuario" DROP CONSTRAINT "FK_eb2c4aa5ed543b544475678b409"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP COLUMN "status"`);
        await queryRunner.query(`DROP TYPE "public"."ocupacao_status_enum"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD "status" integer NOT NULL`);
        await queryRunner.query(`CREATE SEQUENCE IF NOT EXISTS "tipo_granja_id_seq" OWNED BY "tipo_granja"."id"`);
        await queryRunner.query(`ALTER TABLE "tipo_granja" ALTER COLUMN "id" SET DEFAULT nextval('"tipo_granja_id_seq"')`);
        await queryRunner.query(`ALTER TABLE "granja" ADD CONSTRAINT "FK_020becf4951f35bf23161a8968c" FOREIGN KEY ("tipo_granja_id") REFERENCES "tipo_granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "status"`);
        await queryRunner.query(`DROP TYPE "public"."animal_status_enum"`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "status" integer NOT NULL`);
        await queryRunner.query(`CREATE SEQUENCE IF NOT EXISTS "tipo_usuario_id_seq" OWNED BY "tipo_usuario"."id"`);
        await queryRunner.query(`ALTER TABLE "tipo_usuario" ALTER COLUMN "id" SET DEFAULT nextval('"tipo_usuario_id_seq"')`);
        await queryRunner.query(`ALTER TABLE "usuario" ADD CONSTRAINT "FK_eb2c4aa5ed543b544475678b409" FOREIGN KEY ("tipo_usuario_id") REFERENCES "tipo_usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD CONSTRAINT "FK_372dd5fdcb3c52b90e9a60d036f" FOREIGN KEY ("tipo_usuario_id") REFERENCES "tipo_usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP COLUMN "status"`);
        await queryRunner.query(`DROP TYPE "public"."ocupacao_animal_status_enum"`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP COLUMN "data_saida"`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP COLUMN "data_entrada"`);
    }

}
