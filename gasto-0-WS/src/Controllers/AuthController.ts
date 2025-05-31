import { type Request, type Response } from 'express'
import { toNewUserEntry } from '../utils/userParsers'
import { UserServices } from '../Services/User.Services'
import { AuthServices } from '../Services/Auth.Services'
import { showError } from '../utils/utilFunctions'
import { toNonSensitiveUserData, toUserLoginData } from '../Schemas/UserSchemas'

export class AuthController {
  private readonly userServices: UserServices = new UserServices()
  private readonly authServices: AuthServices = new AuthServices()

  login = async (req: Request, res: Response) => {
    try {
      const userLoginData = toUserLoginData(req.body)
      const userRegistered = await this.userServices.getUserByEmail(userLoginData.correo)

      if (userRegistered == null) {
        res.status(401).json({ message: 'Credenciales incorrectas.' })
        return
      }
      const isValidPassword = await AuthServices.comparePassword(
        userLoginData.password,
        userRegistered.password
      )

      if (!isValidPassword) {
        res.status(401).json({ message: 'Credenciales incorrectas.' })
      } else {
        const nonSensitiveUserData = toNonSensitiveUserData(userRegistered)
        const token = this.authServices.generateToken(nonSensitiveUserData)

        res.status(200).json({ user: nonSensitiveUserData, token })
      }
    } catch (error: unknown) {
      const errorMessage = showError(error)
      res.status(400).send(errorMessage)
    }
  }

  register = async (req: Request, res: Response) => {
    try {
      const newUserEntry = toNewUserEntry(req.body)
      const existingUser = await this.userServices.getUserByEmail(
        newUserEntry.correo
      )
      if (existingUser != null) {
        res.status(400).json({ message: 'El correo ya está registrado.' })
      } else {
        const newUser = await this.userServices.createUser(newUserEntry)

        res.status(201).json(newUser)
      }
    } catch (error: unknown) {
      const errorMessage = showError(error)

      res.status(400).send(errorMessage)
    }
  }

   public static async validateEmail (req: Request, res: Response) {
    try {
      const { correo } = req.body
      const userServices = new UserServices()
      const user = await userServices.getUserByEmail(correo)
      if (user) {
        res.status(200).json({ message: 'El correo ya está registrado.' })
      } else {
        res.status(200).json({ message: 'El correo está disponible.' })
      }
    } catch (error: unknown) {
      const errorMessage = showError(error)
      res.status(400).send(errorMessage)
    }
  } 
}
