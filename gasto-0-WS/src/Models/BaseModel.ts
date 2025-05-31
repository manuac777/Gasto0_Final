import { type QueryResult, type QueryResultRow } from 'pg'
import { getClient } from '../db/dbConnection'

export abstract class BaseModel {
  public async query<T extends QueryResultRow>(queryText: string, values?: any[]): Promise<QueryResult<T>> {
    const client = await getClient()
    try {
      return await client.query(queryText, values)
    } finally {
      client.release()
    }
  }

  public async getAll<T extends QueryResultRow>(table: string): Promise<T[]> {
    const query = `SELECT * FROM ${table}`
    const result = await this.query<T>(query)

    return result.rows
  }

  public async create<T extends QueryResultRow>(table: string, data: object): Promise<T> {
    const columns = Object.keys(data).join(', ')
    const values = Object.values(data)
    const placeholders = values.map((_, index) => `$${index + 1}`).join(', ')

    const query = `INSERT INTO ${table} (${columns}) VALUES (${placeholders}) RETURNING *`

    try {
      const result = await this.query<T>(query, values)

      return result.rows[0]
    } catch (error) {
      throw new Error(`Error creando ${table}`)
    }
  }
}
