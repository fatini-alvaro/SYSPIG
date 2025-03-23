import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1742093342136 implements MigrationInterface {
    name = 'Default1742093342136'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" DROP CONSTRAINT "FK_7fbef2bea521527f7f511a8873e"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP COLUMN "ocupacao_id"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" ADD "ocupacao_id" integer`);
        await queryRunner.query(`ALTER TABLE "baia" ADD CONSTRAINT "FK_7fbef2bea521527f7f511a8873e" FOREIGN KEY ("ocupacao_id") REFERENCES "ocupacao"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
