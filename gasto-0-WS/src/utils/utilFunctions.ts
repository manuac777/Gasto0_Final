export const showError = (error: unknown): string => {
  let errorMessage = 'Algo salio mal.'

  if (error instanceof Error) {
    return errorMessage += 'Error: ' + error.message
  }

  return errorMessage
}
