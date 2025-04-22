import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745260593804 implements MigrationInterface {
    name = 'Default1745260593804'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "nascimento" ("id" SERIAL NOT NULL, "data_nascimento" TIMESTAMP DEFAULT now(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "fazenda_id" integer, "animal_id" integer, "matriz_id" integer, "baia_id" integer, "lote_nascimento_id" integer, "lote_animal_nascimento_id" integer, "created_by" integer, "updated_by" integer, CONSTRAINT "PK_e48619b4f211c2defb3ee1596e3" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_cf100e7ec3f13fb20116894a5b9" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_23fc58e285bf41c78db46d5371c" FOREIGN KEY ("animal_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_735ea2e73ebc538c2e83f951e55" FOREIGN KEY ("matriz_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_a6139a1f68b929a887175e97785" FOREIGN KEY ("baia_id") REFERENCES "baia"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_bbaeb0349764eb794b460c28e31" FOREIGN KEY ("lote_nascimento_id") REFERENCES "lote"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_23ee7ac8d89bcb24589683b8c80" FOREIGN KEY ("lote_animal_nascimento_id") REFERENCES "lote_animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_5ca7ac997b36a359fd0ed032ff2" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "nascimento" ADD CONSTRAINT "FK_7d23b8df0084e37a7b7c046be5f" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_7d23b8df0084e37a7b7c046be5f"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_5ca7ac997b36a359fd0ed032ff2"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_23ee7ac8d89bcb24589683b8c80"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_bbaeb0349764eb794b460c28e31"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_a6139a1f68b929a887175e97785"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_735ea2e73ebc538c2e83f951e55"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_23fc58e285bf41c78db46d5371c"`);
        await queryRunner.query(`ALTER TABLE "nascimento" DROP CONSTRAINT "FK_cf100e7ec3f13fb20116894a5b9"`);
        await queryRunner.query(`DROP TABLE "nascimento"`);
    }

}
