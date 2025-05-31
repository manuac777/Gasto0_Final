import { type QueryResultRow } from 'pg'
import { BaseModel } from './BaseModel'

export class ExpenseModel extends BaseModel {
  public async getExpensesByUserId <T extends QueryResultRow>(userId: string): Promise<T[]> {
    try {
      const query = 'SELECT descripcion, monto, categoria, fecha FROM gastos WHERE usuario_id = $1'
      const values = [userId]
      const result = await this.query<T>(query, values)

      return result.rows
    } catch (error) {
      throw new Error('Error al obtener los gastos del usuario')
    }
  }
}
