import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1743985283780 implements MigrationInterface {
    name = 'Default1743985283780'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ADD "nascimento" boolean NOT NULL DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "nascimento"`);
    }

}
