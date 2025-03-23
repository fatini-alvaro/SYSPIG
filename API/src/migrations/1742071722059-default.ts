import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1742071722059 implements MigrationInterface {
    name = 'Default1742071722059'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "ocupacao_animal" ("id" SERIAL NOT NULL, "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "ocupacao_id" integer, "animal_id" integer, "created_by" integer, "updated_by" integer, CONSTRAINT "PK_9aedb48531cbe82ed0cd0e16de9" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD CONSTRAINT "FK_b84dbb1ed2f5ce3366cd5b27956" FOREIGN KEY ("ocupacao_id") REFERENCES "ocupacao"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD CONSTRAINT "FK_cbf164685715b89b88e636254ed" FOREIGN KEY ("animal_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD CONSTRAINT "FK_65c8ec48a0ff3557d7ce65dc5b3" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" ADD CONSTRAINT "FK_59bc810b8776686a31ea0bc9ecd" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP CONSTRAINT "FK_59bc810b8776686a31ea0bc9ecd"`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP CONSTRAINT "FK_65c8ec48a0ff3557d7ce65dc5b3"`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP CONSTRAINT "FK_cbf164685715b89b88e636254ed"`);
        await queryRunner.query(`ALTER TABLE "ocupacao_animal" DROP CONSTRAINT "FK_b84dbb1ed2f5ce3366cd5b27956"`);
        await queryRunner.query(`DROP TABLE "ocupacao_animal"`);
    }

}
