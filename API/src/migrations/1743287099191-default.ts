import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1743287099191 implements MigrationInterface {
    name = 'Default1743287099191'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_6f24bbd4c1b767a25ff25f5be77" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "movimentacao" ADD CONSTRAINT "FK_8ee6cb8fe8d390839d1413b7eb0" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_8ee6cb8fe8d390839d1413b7eb0"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP CONSTRAINT "FK_6f24bbd4c1b767a25ff25f5be77"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "movimentacao" DROP COLUMN "created_at"`);
    }

}
