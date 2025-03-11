import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1741567553106 implements MigrationInterface {
    name = 'Default1741567553106'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" ALTER COLUMN "data" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" ALTER COLUMN "data" SET NOT NULL`);
    }

}
