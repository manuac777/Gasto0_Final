import { z } from 'zod'
import { type NonSensitiveUserData } from '../interfaces/IUsers'

export const UserSchema = z.object({
  id: z.string({ message: 'El id debe ser tipo string' }).uuid({ message: 'El id debe ser un UUID' }),
  nombre: z.string({ message: 'El nombre debe ser tipo string' }).min(1, { message: 'El nombre no puede estar vacio' }),
  edad: z.number({ message: 'La edad debe ser tipo number' }).min(0, { message: 'La edad no puede ser menor a 0' }).max(120, { message: 'La edad no puede ser mayor a 120' }),
  correo: z.string({ message: 'El correo debe ser tipo string' }).email({ message: 'El correo no es valido' }),
  password: z.string({ message: 'La contraseña debe ser tipo string' }).min(8, { message: 'La contraseña debe tener al menos 8 caracteres' })
})

export const UserSchemaWithoutId = UserSchema.omit({ id: true })
export const UserSchemaWithoutPassword = UserSchema.omit({ password: true })
export const UserLoginSchema = UserSchema.pick({ correo: true, password: true })

export function toNonSensitiveUserData (object: unknown): NonSensitiveUserData {
  return UserSchemaWithoutPassword.parse(object)
}

export function validateId (id: unknown): string {
  return UserSchema.parse({ id }).id
}

export function toUserLoginData (object: unknown) {
  return UserLoginSchema.parse(object)
}
