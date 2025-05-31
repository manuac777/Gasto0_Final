import { type User } from '../interfaces/IUsers'
import { BaseModel } from './BaseModel'

export class UserModel extends BaseModel {
  public async getByEmail (email: string): Promise<User> {
    try {
      const query = 'SELECT * FROM usuarios WHERE correo = $1'
      const values = [email]
      const result = await this.query<User>(query, values)

      return result.rows[0]
    } catch (error) {
      throw new Error('Error al obtener el usuario por correo')
    }
  }
}
