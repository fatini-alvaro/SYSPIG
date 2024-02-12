import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1707658512496 implements MigrationInterface {
    name = 'Default1707658512496'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "uf" ADD "nome" text NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "uf" DROP COLUMN "nome"`);
    }

}
