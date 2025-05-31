import { NewUserEntry, NonSensitiveUserData, User } from "../interfaces/IUsers";
import { isString, isNumber } from "./commonParsers";

const parseName = (name: unknown): string => {
    if (!isString(name)) {
        throw new Error("Campo invalido: El campo nombre debe ser de tipo texto");
    }
    return name;
}

const parseEdad = (edad: unknown): number => {
    if (!isNumber(edad)) {
        throw new Error("Campo invalido: La edad debe ser un numero entero");
    }

    if (edad < 0 || edad > 120) {
        throw new Error("Invalid field: edad must be in a correct range (0-120)");
    }

    return edad;
}

export const parseCorreo = (correo: unknown): string => {
    if (!isString(correo)) {
        throw new Error("Campo invalido: El correo debe ser de tipo texto");
    }
    const regex: RegExp = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!regex.test(correo)) {
        throw new Error("Campo invalido: El campo correo no es una direccion de correo valida");
    }
    return correo;
}

const parsePassword = (password: unknown): string => {
    if (!isString(password)) {
        throw new Error("Campo invalido: La contraseña debe ser de tipo texto");
    }
    
    if (password.length < 8) {
        throw new Error("Invalid field: password must be at least 8 characters long");
    }
    return password;
}

export const toNewUserEntry = (object: unknown): NewUserEntry => {
    if(!object || typeof object !== "object"){
        throw new Error("Datos invalidos");
    }

    if('nombre' in object && 'edad' in object && 'correo' in object && 'password' in object){
        const newUser: NewUserEntry = {
            nombre: parseName(object.nombre),
            edad: parseEdad(object.edad),
            correo: parseCorreo(object.correo),
            password: parsePassword(object.password)
        };
        
        return newUser;
    }

    throw new Error("Datos invalidos: Faltan campos requeridos");
};

export const toNonSensitiveUserData = (user: User): NonSensitiveUserData => {
    const { id, nombre, edad, correo} = user;
    return { id, nombre, edad, correo } as NonSensitiveUserData;
}