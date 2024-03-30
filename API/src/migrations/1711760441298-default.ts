import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1711760441298 implements MigrationInterface {
    name = 'Default1711760441298'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "usuario" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "usuario" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "granja" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "granja" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "granja" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "granja" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "animal" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "baia" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "baia" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "baia" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "baia" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "created_by" integer`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD "updated_by" integer`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD CONSTRAINT "FK_bca5880a0030b97753645dd58ae" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "cidade" ADD CONSTRAINT "FK_a8540019e855b3aefb536d20f47" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD CONSTRAINT "FK_a52c3d0649af2ae7780e011562b" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "fazenda" ADD CONSTRAINT "FK_17f478e99a41bac76a883b2ff73" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "granja" ADD CONSTRAINT "FK_308dd338b50687449394dfb8761" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "granja" ADD CONSTRAINT "FK_00ef94dc0de4e3afdb6d87463eb" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_2870fef74f23b76670bce446852" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "animal" ADD CONSTRAINT "FK_f965bcd387918a45424aa69cef9" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_acf7fe920b5073f4a7ffea53dbd" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "inseminacao" ADD CONSTRAINT "FK_645c11447eef1cc2ae0fcd5da1c" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "baia" ADD CONSTRAINT "FK_24b0988a8d6f988e08ccca4523c" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "baia" ADD CONSTRAINT "FK_367315e5d1c0555ed215f781717" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD CONSTRAINT "FK_2c6858b7930956bc323dd356f2b" FOREIGN KEY ("created_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "anotacao" ADD CONSTRAINT "FK_b756fea6b7ebcc810e548a84984" FOREIGN KEY ("updated_by") REFERENCES "usuario"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anotacao" DROP CONSTRAINT "FK_b756fea6b7ebcc810e548a84984"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP CONSTRAINT "FK_2c6858b7930956bc323dd356f2b"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP CONSTRAINT "FK_367315e5d1c0555ed215f781717"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP CONSTRAINT "FK_24b0988a8d6f988e08ccca4523c"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_645c11447eef1cc2ae0fcd5da1c"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP CONSTRAINT "FK_acf7fe920b5073f4a7ffea53dbd"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_f965bcd387918a45424aa69cef9"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP CONSTRAINT "FK_2870fef74f23b76670bce446852"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP CONSTRAINT "FK_00ef94dc0de4e3afdb6d87463eb"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP CONSTRAINT "FK_308dd338b50687449394dfb8761"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP CONSTRAINT "FK_17f478e99a41bac76a883b2ff73"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP CONSTRAINT "FK_a52c3d0649af2ae7780e011562b"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP CONSTRAINT "FK_a8540019e855b3aefb536d20f47"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP CONSTRAINT "FK_bca5880a0030b97753645dd58ae"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "anotacao" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "baia" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "inseminacao" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "animal" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "granja" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "usuario" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "usuario" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "fazenda" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP COLUMN "updated_by"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP COLUMN "created_by"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "cidade" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "usuario_fazenda" DROP COLUMN "created_at"`);
    }

}
