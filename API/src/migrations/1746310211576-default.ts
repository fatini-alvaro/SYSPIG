import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1746310211576 implements MigrationInterface {
    name = 'Default1746310211576'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "usuario" ADD CONSTRAINT "FK_ccd0cea686b10f1b53aff35e39d" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" DROP CONSTRAINT "FK_ccd0cea686b10f1b53aff35e39d"`);
        await queryRunner.query(`ALTER TABLE "usuario" DROP COLUMN "created_by"`);
    }

}
