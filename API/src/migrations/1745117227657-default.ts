import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745117227657 implements MigrationInterface {
    name = 'Default1745117227657'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "lote" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_b13932612f8840d62b8cf1ca14b" FOREIGN KEY ("lote") REFERENCES "lote"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_b13932612f8840d62b8cf1ca14b"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "lote"`);
    }

}
