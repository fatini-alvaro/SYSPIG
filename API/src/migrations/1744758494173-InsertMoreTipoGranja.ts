import { MigrationInterface, QueryRunner } from "typeorm";

export class InsertMoreTipoGranja1744758494173 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            INSERT INTO tipo_granja (id, descricao) VALUES 
            (3, 'Creche'),
            (4, 'Inseminação')
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DELETE FROM tipo_granja WHERE id IN (3, 4)
        `);
    }

}
