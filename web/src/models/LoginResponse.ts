import { User } from './User';

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: User;
}
