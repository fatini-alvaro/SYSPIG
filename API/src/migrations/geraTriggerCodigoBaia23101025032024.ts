import { MigrationInterface, QueryRunner } from "typeorm";

export class geraTriggerCodigoBaia23101025032024 implements MigrationInterface {
    name = 'geraTriggerCodigoBaia23101025032024'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            CREATE OR REPLACE FUNCTION calcular_proximo_codigo_baia()
            RETURNS TRIGGER AS $$
            DECLARE
                proximo_codigo INTEGER;
            BEGIN
                -- Obter o próximo código da baia para a fazenda específica
                SELECT COALESCE(MAX(codigo), 0) + 1 INTO proximo_codigo
                FROM baia
                WHERE fazenda_id = NEW.fazenda_id;

                -- Atribuir o próximo código ao novo registro
                NEW.codigo := proximo_codigo;

                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER atualizar_codigo_baia
            BEFORE INSERT ON baia
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo_baia();
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DROP TRIGGER atualizar_codigo_baia ON baia;
            DROP FUNCTION calcular_proximo_codigo_baia();
        `);
    }

}
