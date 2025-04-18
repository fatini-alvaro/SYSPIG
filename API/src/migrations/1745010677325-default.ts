import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745010677325 implements MigrationInterface {
    name = 'Default1745010677325'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "baia_id" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_30b40a3e03970dc1f23f0cbddfb" FOREIGN KEY ("baia_id") REFERENCES "baia"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_30b40a3e03970dc1f23f0cbddfb"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "baia_id"`);
    }

}
