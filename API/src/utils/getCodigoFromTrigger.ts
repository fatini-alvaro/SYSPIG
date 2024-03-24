
import { DataSource, DataSourceOptions, QueryBuilder } from "typeorm";
import { AppDataSource } from "../data-source";

export async function getCodigoFromTrigger(id: number, entityName: string): Promise<number> {

  const codigo = await AppDataSource.query(`
    SELECT codigo
    FROM ${entityName}
    WHERE id = ${id};
  `);

  return 0;
}
