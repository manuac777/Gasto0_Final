import { z } from 'zod'
import { type ExpenseToShow, type NewExpenseEntry } from '../interfaces/Expenses'

export const ExpenseSchema = z.object({
  gasto_id: z.number(),
  usuario_id: z.string().uuid(),
  descripcion: z.string(),
  monto: z.number().positive(),
  categoria: z.string(),
  fecha: z.string()
})

export const NewExpenseSchema = ExpenseSchema.omit({ gasto_id: true })
export const ExpenseToShowSchema = ExpenseSchema.omit({ usuario_id: true, gasto_id: true })

export function toExpenseToShow (object: unknown): ExpenseToShow {
  return ExpenseToShowSchema.parse(object)
}

export function toNewExpenseEntry (object: unknown): NewExpenseEntry {
  return NewExpenseSchema.parse(object)
}
