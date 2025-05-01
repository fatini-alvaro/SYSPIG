'use client';

import Cookie from 'js-cookie';

export const logout = (router: any) => {
  Cookie.remove('accessToken');
  Cookie.remove('refreshToken');
  Cookie.remove('user');
  Cookie.remove('selectedFarmId');

  router.push('/login');
};
