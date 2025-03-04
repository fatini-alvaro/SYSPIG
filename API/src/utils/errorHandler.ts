import { Response } from "express";
import { QueryFailedError } from "typeorm";
import { ValidationError } from "./validationError";

export const handleError = (error: unknown, res: Response, defaultMessage: string) => {
  let statusCode = 500;
  let errorMessage = defaultMessage;

  if (error instanceof ValidationError) {
    statusCode = error.statusCode;
    errorMessage = error.message;
  } else if (error instanceof QueryFailedError) {
    // Detecta erro de chave estrangeira
    if ((error as any).message.includes("violates foreign key constraint")) {
      errorMessage = "Não é possível excluir este registro, pois ele está vinculado a outros dados no sistema.";
      statusCode = 400;
    } else {
      errorMessage = "Erro ao processar a requisição.";
    }
  } else if (error instanceof Error) {
    errorMessage = error.message;
  }

  console.error("Erro:", errorMessage);
  return res.status(statusCode).json({ message: errorMessage });
};
