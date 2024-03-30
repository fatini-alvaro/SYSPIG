import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711418260470 implements MigrationInterface {
    name = 'Default1711418260470'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" ALTER COLUMN "capacidade" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "baia" ALTER COLUMN "capacidade" SET NOT NULL`);
    }

}
