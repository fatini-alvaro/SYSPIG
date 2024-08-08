import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711765528454 implements MigrationInterface {
    name = 'Default1711765528454'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_ae3dc2080f6b5a154ed71a21fd1"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_ae3dc2080f6b5a154ed71a21fd1" FOREIGN KEY ("baia_id") REFERENCES "baia"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "ocupacao" DROP CONSTRAINT "FK_ae3dc2080f6b5a154ed71a21fd1"`);
        await queryRunner.query(`ALTER TABLE "ocupacao" ADD CONSTRAINT "FK_ae3dc2080f6b5a154ed71a21fd1" FOREIGN KEY ("baia_id") REFERENCES "ocupacao"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
