import { Router } from 'express'
import { authMiddleware } from '../middlewares/auth.middleware'
import { ExpenseController } from '../Controllers/ExpenseController'

const router = Router()

const expenseController: ExpenseController = new ExpenseController()

router.post('/agregar_gasto', authMiddleware, expenseController.addExpense)
router.get('/ver_gastos', authMiddleware, expenseController.getExpensesByUserId)
export default router
