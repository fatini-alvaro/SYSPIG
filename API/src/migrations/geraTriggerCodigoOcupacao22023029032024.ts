import { MigrationInterface, QueryRunner } from "typeorm";

export class geraTriggerCodigoOcupacao22023029032024 implements MigrationInterface {
    name = 'geraTriggerCodigoOcupacao22023029032024'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            CREATE OR REPLACE TRIGGER atualizar_codigo_ocupacao
            BEFORE INSERT ON ocupacao
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo();
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Remover as triggers e a função PL/pgSQL
        await queryRunner.query(`
            DROP TRIGGER atualizar_codigo_ocupacao ON ocupacao;
        `);
    }

}
