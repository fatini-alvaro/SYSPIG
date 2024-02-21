import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707768115416 implements MigrationInterface {
    name = 'Default1707768115416'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "granja" ("id" SERIAL NOT NULL, "descricao" text NOT NULL, "codigo" integer NOT NULL, "capacidade" integer NOT NULL, "fazenda_id" integer, "tipo_granja_id" integer, CONSTRAINT "PK_f4ed5e8260f7aa90f202a9d5b72" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "tipo_granja" ("id" SERIAL NOT NULL, "descricao" text NOT NULL, CONSTRAINT "PK_6396ea8504e83c4de9e3db7882f" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "granja" ADD CONSTRAINT "FK_134756ad510ca1ef23460b9a892" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "granja" ADD CONSTRAINT "FK_020becf4951f35bf23161a8968c" FOREIGN KEY ("tipo_granja_id") REFERENCES "tipo_granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "granja" DROP CONSTRAINT "FK_020becf4951f35bf23161a8968c"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP CONSTRAINT "FK_134756ad510ca1ef23460b9a892"`);
        await queryRunner.query(`DROP TABLE "tipo_granja"`);
        await queryRunner.query(`DROP TABLE "granja"`);
    }

}
