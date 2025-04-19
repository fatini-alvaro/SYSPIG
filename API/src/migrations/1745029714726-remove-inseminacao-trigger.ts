import { MigrationInterface, QueryRunner } from "typeorm";

export class RemoveInseminacaoTrigger11745029714726 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DROP TRIGGER IF EXISTS atualizar_codigo_inseminacao ON inseminacao;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TRIGGER atualizar_codigo_inseminacao
      BEFORE INSERT ON inseminacao
      FOR EACH ROW
      EXECUTE FUNCTION calcular_proximo_codigo();
    `);
  }
}
