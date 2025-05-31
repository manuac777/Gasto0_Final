import { Pool } from 'pg'
import { config } from './config'

export const getClient = async () => {
  const pool = new Pool(config)
  const client = await pool.connect()

  return client
}
