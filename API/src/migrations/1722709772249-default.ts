import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722709772249 implements MigrationInterface {
    name = 'Default1722709772249'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            CREATE OR REPLACE TRIGGER atualizar_codigo_baia
            BEFORE INSERT ON baia
            FOR EACH ROW
            EXECUTE FUNCTION calcular_proximo_codigo();
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Remover as triggers e a função PL/pgSQL
        await queryRunner.query(`
            DROP TRIGGER atualizar_codigo_baia ON baia;
        `);
    }

}
