import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745268344365 implements MigrationInterface {
    name = 'Default1745268344365'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "data_ultima_cria" DROP DEFAULT`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "data_ultima_cria" SET DEFAULT now()`);
    }

}
