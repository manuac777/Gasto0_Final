import { type Response, type NextFunction } from 'express'
import { AuthServices } from '../Services/Auth.Services'
import { type AuthRequest } from '../interfaces/express'
import { toNonSensitiveUserData } from '../Schemas/UserSchemas'

export const authMiddleware = (req: AuthRequest, res: Response, next: NextFunction) => {
  const authServices: AuthServices = new AuthServices()
  const token = req.headers.authorization?.split(' ')[1]

  if (token === null || token === undefined) {
    res.status(401).json({ message: 'No autorizado' })
  } else {
    try {
      const decoded = authServices.verifyToken(token)
      req.user = toNonSensitiveUserData(decoded)
      next()
    } catch (error) {
      console.log(error)
      res.status(401).json({ message: 'Token no valido' })
    }
  }
}
