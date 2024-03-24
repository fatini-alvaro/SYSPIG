import { MigrationInterface, QueryRunner } from "typeorm";

export class geraTriggerCodigoGranja16345678901235 implements MigrationInterface {
    name = 'geraTriggerCodigoGranja16345678901235'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            CREATE OR REPLACE FUNCTION calcular_proximo_codigo_granja()
            RETURNS TRIGGER AS $$
            DECLARE
                proximo_codigo INTEGER;
            BEGIN
                -- Obter o próximo código da granja para a fazenda específica
                SELECT COALESCE(MAX(codigo), 0) + 1 INTO proximo_codigo
                FROM granja
                WHERE fazenda_id = NEW.fazenda_id;

                -- Atribuir o próximo código ao novo registro
                NEW.codigo := proximo_codigo;

                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER atualizar_codigo_granja
            BEFORE INSERT ON granja
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo_granja();
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DROP TRIGGER atualizar_codigo_granja ON granja;
            DROP FUNCTION calcular_proximo_codigo_granja();
        `);
    }

}
