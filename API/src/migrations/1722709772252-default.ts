import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722709772252 implements MigrationInterface {
    name = 'Default1722709772252'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            INSERT INTO tipo_usuario (id, descricao) VALUES 
            (1, 'Dono'),
            (2, 'Funcionário')
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DELETE FROM tipo_usuario WHERE id IN (1, 2);
        `);
    }

}
