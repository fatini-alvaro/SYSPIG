import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1743986830624 implements MigrationInterface {
    name = 'Default1743986830624'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "numero_brinco" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "sexo" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "sexo" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "animal" ALTER COLUMN "numero_brinco" SET NOT NULL`);
    }

}
