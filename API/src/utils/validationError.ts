export class ValidationError extends Error {
    statusCode: number;
  
    constructor(message: string, statusCode: number = 400) {
      super(message);
      this.name = "ValidationError";
      this.statusCode = statusCode;
    }
  }
  