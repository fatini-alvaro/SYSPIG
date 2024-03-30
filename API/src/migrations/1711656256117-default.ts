import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711656256117 implements MigrationInterface {
    name = 'Default1711656256117'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "data_nascimento" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "data_nascimento" SET NOT NULL`);
    }

}
