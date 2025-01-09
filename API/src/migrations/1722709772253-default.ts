import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722709772253 implements MigrationInterface {
    name = 'Default1722709772253'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            INSERT INTO tipo_granja (id, descricao) VALUES 
            (1, 'Gestação'),
            (2, 'Engorda')
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DELETE FROM tipo_granja WHERE id IN (1, 2);
        `);
    }

}
