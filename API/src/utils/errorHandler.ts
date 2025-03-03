import { Response } from "express";
import { ValidationError } from "./validationError"; // Importa a classe de erro customizada

export const handleError = (error: unknown, res: Response, defaultMessage: string) => {
  let statusCode = 500;
  let errorMessage = defaultMessage;

  if (error instanceof ValidationError) {
    statusCode = error.statusCode;
    errorMessage = error.message;
  } else if (error instanceof Error) {
    errorMessage = error.message;
  }

  console.error("Erro:", errorMessage);
  return res.status(statusCode).json({ message: errorMessage });
};
