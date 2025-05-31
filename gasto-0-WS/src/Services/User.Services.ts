import { type NewUserEntry, type User } from '../interfaces/IUsers'
import { randomUUID } from 'crypto'
import { UserModel } from '../Models/UserModel'
import { AuthServices } from './Auth.Services'

export class UserServices {
  private readonly userRepository = new UserModel()

  public async getAllUsers (): Promise<User[]> {
    const table = 'usuarios'
    return await this.userRepository.getAll<User>(table)
  }

  public async createUser (dataUser: NewUserEntry): Promise<User> {
    const id = randomUUID()
    const { nombre, edad, correo, password } = dataUser
    const hashedPassword = await AuthServices.hashPassword(password)

    const values: User = { id, nombre, edad, correo, password: hashedPassword }
    const table = 'usuarios'

    return await this.userRepository.create<User>(table, values)
  }

  public async getUserByEmail (correo: string): Promise<User> {
    return await this.userRepository.getByEmail(correo)
  }
}
