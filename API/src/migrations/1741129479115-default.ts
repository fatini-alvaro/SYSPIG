import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1741129479115 implements MigrationInterface {
    name = 'Default1741129479115'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote" ALTER COLUMN "data" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "lote" ALTER COLUMN "data" SET NOT NULL`);
    }

}
