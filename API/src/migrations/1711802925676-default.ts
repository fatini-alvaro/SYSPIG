import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711802925676 implements MigrationInterface {
    name = 'Default1711802925676'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_9aedb48531cbe82ed0cd0e16de9"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_9aedb48531cbe82ed0cd0e16de9" FOREIGN KEY ("animal_id") REFERENCES "animal"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_9aedb48531cbe82ed0cd0e16de9"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_9aedb48531cbe82ed0cd0e16de9" FOREIGN KEY ("animal_id") REFERENCES "granja"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
