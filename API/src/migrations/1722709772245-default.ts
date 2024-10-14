import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722709772245 implements MigrationInterface {
    name = 'Default1722709772245'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Criar a função PL/pgSQL para calcular o próximo código sem argumentos
        await queryRunner.query(`
            CREATE OR REPLACE FUNCTION calcular_proximo_codigo()
            RETURNS TRIGGER AS $$
            DECLARE
                tabela_name TEXT;
                proximo_codigo INTEGER;
            BEGIN
                -- Obter o nome da tabela
                tabela_name := TG_TABLE_NAME;

                -- Obter o próximo código da tabela específica
                EXECUTE 'SELECT COALESCE(MAX(codigo), 0) + 1 FROM ' || tabela_name || ' WHERE fazenda_id = ' || NEW.fazenda_id INTO proximo_codigo;

                -- Atribuir o próximo código ao novo registro
                NEW.codigo := proximo_codigo;

                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;
        `);

        // Criar triggers para as tabelas desejadas
        await queryRunner.query(`
            CREATE OR REPLACE TRIGGER atualizar_codigo_animal
            BEFORE INSERT ON animal
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo();

            CREATE OR REPLACE TRIGGER atualizar_codigo_anotacao
            BEFORE INSERT ON anotacao
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo();

            CREATE OR REPLACE TRIGGER atualizar_codigo_inseminacao
            BEFORE INSERT ON inseminacao
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo();

            CREATE OR REPLACE TRIGGER atualizar_codigo_anotacao
            BEFORE INSERT ON anotacao
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo();
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Remover as triggers e a função PL/pgSQL
        await queryRunner.query(`
            DROP TRIGGER atualizar_codigo_animal ON animal;
            DROP TRIGGER atualizar_codigo_anotacao ON anotacao;
            DROP TRIGGER atualizar_codigo_inseminacao ON inseminacao;
            DROP TRIGGER atualizar_codigo_anotacao ON anotacao;
            DROP FUNCTION calcular_proximo_codigo;
        `);
    }

}
