import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1742129764725 implements MigrationInterface {
    name = 'Default1742129764725'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "ocupacao_id" integer`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD CONSTRAINT "FK_7fafe8bb19369142b35870156df" FOREIGN KEY ("ocupacao_id") REFERENCES "ocupacao"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" DROP CONSTRAINT "FK_7fafe8bb19369142b35870156df"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "ocupacao_id"`);
    }

}
