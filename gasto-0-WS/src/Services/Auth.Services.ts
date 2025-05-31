import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'
import { type NonSensitiveUserData } from '../interfaces/IUsers'

export class AuthServices {
  private readonly JWT_SECRET = 'nR9XKp5Yv2bQlLz8wE6jGtH1sNmO3cPq7IiJyUo4Vf0='
  private readonly JWT_EXPIRATION = '1d'

  public static async hashPassword (password: string): Promise<string> {
    return await bcrypt.hash(password, 10)
  }

  public static async comparePassword (password: string, hasedPassword: string) {
    return await bcrypt.compare(password, hasedPassword)
  }

  public generateToken (user: NonSensitiveUserData): string {
    return jwt.sign(
      user,
      this.JWT_SECRET,
      { expiresIn: this.JWT_EXPIRATION }
    )
  }

  public verifyToken (token: string) {
    return jwt.verify(token, this.JWT_SECRET)
  }
}
