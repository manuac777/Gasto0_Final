import { type Response } from 'express'
import { type AuthRequest } from '../interfaces/express'
import { ExpensesService } from '../Services/ExpensesService'
import { type NewExpenseEntry } from '../interfaces/Expenses'
import { showError } from '../utils/utilFunctions'
import { toNewExpenseEntry } from '../Schemas/ExpenseSchemas'

export class ExpenseController {
  private readonly expensesService: ExpensesService = new ExpensesService()
  addExpense = async (req: AuthRequest, res: Response) => {
    try {
      const expenseToAdd: NewExpenseEntry = toNewExpenseEntry({ usuario_id: req.user?.id, ...req.body })
      const newExpense = await this.expensesService.addExpense(expenseToAdd)

      res.status(201).json({ message: 'Gasto agregado correctamente', newExpense })
    } catch (error: unknown) {
      const errorMessage = showError(error)

      res.status(400).send(errorMessage)
    }
  }

  getExpensesByUserId = async (req: AuthRequest, res: Response) => {
    try {
      const userId = req.user?.id
      if (userId !== undefined) {
        const expenses = await this.expensesService.getExpensesByUserId(userId)

        if (expenses.length < 1) {
          res.status(404).json({ message: 'No se encontraron gastos para este usuario' })
        } else {
          res.status(200).json({ message: 'Gastos obtenidos correctamente', expenses })
        }
      }
    } catch (error) {
      const errorMessage = showError(error)

      res.status(400).send(errorMessage)
    }
  }
}
