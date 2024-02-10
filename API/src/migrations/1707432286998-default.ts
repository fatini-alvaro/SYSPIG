import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707432286998 implements MigrationInterface {
    name = 'Default1707432286998'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" ADD "senha" character varying NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario" DROP COLUMN "senha"`);
    }

}
