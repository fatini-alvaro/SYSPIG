import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1713483423424 implements MigrationInterface {
    name = 'Default1713483423424'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "codigo" integer`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "baia_id" integer`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD CONSTRAINT "FK_256215139ee70a730471932f89e" FOREIGN KEY ("baia_id") REFERENCES "baia"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" DROP CONSTRAINT "FK_256215139ee70a730471932f89e"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "baia_id"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "codigo"`);
    }

}
