import { type Request } from 'express'
import { type NonSensitiveUserData } from './IUsers'

export interface AuthRequest extends Request {
  user?: NonSensitiveUserData
}
