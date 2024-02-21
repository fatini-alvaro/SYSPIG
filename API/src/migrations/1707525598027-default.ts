import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707525598027 implements MigrationInterface {
    name = 'Default1707525598027'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "usuario_fazenda" ("id" SERIAL NOT NULL, "tipo_usuario_id" integer, "usuario_id" integer, "fazenda_id" integer, CONSTRAINT "PK_35c46fce1031f6cb48337a14130" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD "usuario_id" integer`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD CONSTRAINT "FK_d4ffea4d657c424495685abf3fc" FOREIGN KEY ("usuario_id") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD CONSTRAINT "FK_372dd5fdcb3c52b90e9a60d036f" FOREIGN KEY ("tipo_usuario_id") REFERENCES "tipo_usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD CONSTRAINT "FK_d936e99971c08b6d4422a636e8b" FOREIGN KEY ("usuario_id") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD CONSTRAINT "FK_132feb1a8d2eebdd586cb4375ff" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP CONSTRAINT "FK_132feb1a8d2eebdd586cb4375ff"`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP CONSTRAINT "FK_d936e99971c08b6d4422a636e8b"`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP CONSTRAINT "FK_372dd5fdcb3c52b90e9a60d036f"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP CONSTRAINT "FK_d4ffea4d657c424495685abf3fc"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP COLUMN "usuario_id"`);
        await queryRunner.query(`DROP TABLE "usuario_fazenda"`);
    }

}
