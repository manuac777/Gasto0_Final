export interface Config {
  user: string
  password: string
  host: string
  port: number
  database: string
}

export const config: Config = {
  user: 'postgres',
  password: 'linux',
  host: 'localhost',
  port: 5432,
  database: 'gasto'
}
