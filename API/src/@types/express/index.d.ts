import { Request, Response, NextFunction } from 'express';
import { JwtPayload } from 'jsonwebtoken';

// Tipo para nossos handlers assíncronos
export type AsyncHandler = (
  req: Request,
  res: Response,
  next: NextFunction
) => Promise<void | Response>;

declare global {
  namespace Express {
    interface Request {
      user?: string | JwtPayload;
    }
  }
}

export {};