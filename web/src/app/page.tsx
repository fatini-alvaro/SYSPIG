'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Cookie from 'js-cookie';

export default function Home() {
  const router = useRouter();

  useEffect(() => {
    const selectedFarmId = Cookie.get('selectedFarmId');
    
    if (!selectedFarmId) {
      router.push('/selecionar-fazenda');
    } else {
      router.push('/dashboard');
    }
  }, [router]);

  return null;
}