import { type ExpenseToShow, type Expense, type NewExpenseEntry } from '../interfaces/Expenses'
import { ExpenseModel } from '../Models/ExpenseModel'

export class ExpensesService {
  private readonly expenseRepository = new ExpenseModel()

  public async addExpense (expenseToAdd: NewExpenseEntry) {
    return await this.expenseRepository.create<Expense>('gastos', expenseToAdd)
  }

  public async getExpensesByUserId (userId: string) {
    return await this.expenseRepository.getExpensesByUserId<ExpenseToShow>(userId)
  }
}
