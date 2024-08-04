import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722709772243 implements MigrationInterface {
    name = 'Default1722709772243'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "lote_animal" ("id" SERIAL NOT NULL, "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "lote_id" integer, "animal_id" integer, "created_by" integer, "updated_by" integer, CONSTRAINT "PK_0dd36731c44e1f6c407ec97e660" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "lote_animal" ADD CONSTRAINT "FK_d0e14b076a2da52bdec3ce56bff" FOREIGN KEY ("lote_id") REFERENCES "lote"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lote_animal" ADD CONSTRAINT "FK_4037977e47b97f632e372e46a6c" FOREIGN KEY ("animal_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lote_animal" ADD CONSTRAINT "FK_9f761af76eebcd2b88f5eb8aa7a" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "lote_animal" ADD CONSTRAINT "FK_0661e1b7c8990ef710b814debf7" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote_animal" DROP CONSTRAINT "FK_0661e1b7c8990ef710b814debf7"`);
        await queryRunner.query(`ALTER TABLE "lote_animal" DROP CONSTRAINT "FK_9f761af76eebcd2b88f5eb8aa7a"`);
        await queryRunner.query(`ALTER TABLE "lote_animal" DROP CONSTRAINT "FK_4037977e47b97f632e372e46a6c"`);
        await queryRunner.query(`ALTER TABLE "lote_animal" DROP CONSTRAINT "FK_d0e14b076a2da52bdec3ce56bff"`);
        await queryRunner.query(`DROP TABLE "lote_animal"`);
    }

}
