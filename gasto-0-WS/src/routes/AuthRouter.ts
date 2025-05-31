import { Router } from 'express'
import { AuthController } from '../Controllers/AuthController'

const router = Router()

const authController: AuthController = new AuthController()

router.post('/login', authController.login)
router.post('/register', authController.register)

export default router
