import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707773666808 implements MigrationInterface {
    name = 'Default1707773666808'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "granja" ALTER COLUMN "codigo" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "granja" ALTER COLUMN "codigo" SET NOT NULL`);
    }

}
