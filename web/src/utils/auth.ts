import Cookie from 'js-cookie';
import { User } from '../models/User';

export function getLoggedUser(): User | null {
  const userCookie = Cookie.get('user');

  if (userCookie) {
    try {
      return JSON.parse(userCookie) as User;
    } catch (error) {
      console.error('Erro ao parsear user do cookie', error);
      return null;
    }
  }

  return null;
}
