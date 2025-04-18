import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1745010750177 implements MigrationInterface {
    name = 'Default1745010750177'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "fazenda_id" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_2004c7b9803ed6768a46e5b58b1" FOREIGN KEY ("fazenda_id") REFERENCES "fazenda"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_2004c7b9803ed6768a46e5b58b1"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "fazenda_id"`);
    }

}
