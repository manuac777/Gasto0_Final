import { Router } from 'express'
import { UserController } from '../Controllers/UserController'

const router: Router = Router()

const userController: UserController = new UserController()

router.get('/', userController.getAllUsers)
router.post('/', userController.getUserByEmail)

export default router
