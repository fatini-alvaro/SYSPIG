'use client';

import Cookie from 'js-cookie';
import { useRouter } from 'next/navigation';

export const logout = (router: ReturnType<typeof useRouter>) => {
  Cookie.remove('accessToken');
  Cookie.remove('refreshToken');
  Cookie.remove('user');
  Cookie.remove('selectedFarmId');

  router.push('/login');
};
