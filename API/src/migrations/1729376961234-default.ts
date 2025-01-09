import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1729376961234 implements MigrationInterface {
    name = 'Default1729376961234'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "status"`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "status" integer NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "status"`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "status" text NOT NULL`);
    }

}
