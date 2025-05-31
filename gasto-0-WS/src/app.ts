import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors'
import userRouter from './routes/UserRouter'
import AuthRouter from './routes/AuthRouter'
import ExpenseRouter from './routes/ExpenseRouter'

dotenv.config()

const app = express()
app.use(express.json())
app.use(cors())

const PORT = process.env.PORT ?? 3000

app.get('/', (_req, res) => {
  res.send('Hello, World!')
})

app.use('/api/users', userRouter)
app.use('/api/auth', AuthRouter)
app.use('/api/gastos', ExpenseRouter)

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`)
})
