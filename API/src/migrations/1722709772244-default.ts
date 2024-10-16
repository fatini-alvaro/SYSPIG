import { MigrationInterface, QueryRunner } from "typeorm";

export class Default1722709772244 implements MigrationInterface {

  name = 'Default1722709772244';

  public async up(queryRunner: QueryRunner): Promise<void> {    
    await queryRunner.query(`
      INSERT INTO uf (nome, sigla) VALUES
      ('Acre', 'AC'),
      ('Alagoas', 'AL'),
      ('Amazonas', 'AM'),
      ('Amapá', 'AP'),
      ('Bahia', 'BA'),
      ('Ceará', 'CE'),
      ('Distrito Federal', 'DF'),
      ('Espírito Santo', 'ES'),
      ('Goiás', 'GO'),
      ('Maranhão', 'MA'),
      ('Minas Gerais', 'MG'),
      ('Mato Grosso do Sul', 'MS'),
      ('Mato Grosso', 'MT'),
      ('Pará', 'PA'),
      ('Paraíba', 'PB'),
      ('Pernambuco', 'PE'),
      ('Piauí', 'PI'),
      ('Paraná', 'PR'),
      ('Rio de Janeiro', 'RJ'),
      ('Rio Grande do Norte', 'RN'),
      ('Rondônia', 'RO'),
      ('Roraima', 'RR'),
      ('Rio Grande do Sul', 'RS'),
      ('Santa Catarina', 'SC'),
      ('Sergipe', 'SE'),
      ('São Paulo', 'SP'),
      ('Tocantins', 'TO');
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query("DROP TABLE uf;");
  }
}
