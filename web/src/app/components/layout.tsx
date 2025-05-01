'use client';

import { logo } from '@/assets/logos';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import Cookie from 'js-cookie';
import { logout } from '@/services/logout';

export default function Layout({ children }: { children: React.ReactNode }) {
  const router = useRouter();

  const handleLogout = () => {
    logout(router);
  };

  return (
    <div className="flex min-h-screen bg-background">
      {/* Sidebar */}
      <aside className="w-64 bg-primary text-onPrimary flex flex-col">
        <div className="p-6 flex items-center justify-center border-b border-orange-300">
          <Image src={logo} alt="Logo Syspig" width={120} height={40} />
        </div>
        <nav className="flex-1 p-4 space-y-4">
          <button 
            className="w-full text-left text-onPrimary hover:bg-orange-400 p-2 rounded"
            onClick={() => router.push('/dashboard')}
          >
            Dashboard
          </button>
          {/* Mais opções de menu aqui */}
        </nav>
        <div className="p-4">
          <button 
            className="w-full bg-error text-onPrimary p-2 rounded hover:bg-red-700"
            onClick={handleLogout}
          >
            Sair
          </button>
        </div>
      </aside>

      {/* Conteúdo principal */}
      <main className="flex-1 flex flex-col">
        {/* Header */}
        <header className="bg-surface shadow p-4 flex justify-between items-center">
          <h1 className="text-primary text-xl font-bold">Syspig</h1>
          {/* Você pode adicionar perfil do usuário aqui depois */}
        </header>

        {/* Conteúdo */}
        <div className="p-6 flex-1 bg-background">
          {children}
        </div>
      </main>
    </div>
  );
}
