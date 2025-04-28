'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Cookie from 'js-cookie';
import apiClient from '../../apiClient';
import { LoginResponse } from '../../models/LoginResponse';
import { User } from '../../models/User';
import { logo, logoBlack } from '../../assets/logos'; // Importe as logos

const LoginPage = () => {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    const token = Cookie.get('accessToken');
    if (token) {
      router.replace('/');
    }
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await apiClient.post<LoginResponse>('/auth', { email, senha });
      const data = response.data;

      Cookie.set('accessToken', data.accessToken, { expires: 1 });
      Cookie.set('refreshToken', data.refreshToken, { expires: 7 });
      Cookie.set('user', JSON.stringify(data.user), { expires: 1 });

      router.push('/');
    } catch (error: any) {
      setErro(error.response?.data?.message || 'Erro ao fazer login');
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50"> {/* Fundo claro */}
      <div className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
      <div className="text-center mb-4">
        <img src={logo.src} alt="Logo" className="w-70 h-auto mx-auto" />
      </div>
        <h1 className="text-2xl font-bold mb-6 text-center text-orange-600"> {/* Título laranja */}
          Entrar
        </h1>

        {erro && (
          <div className="bg-red-100 text-red-700 p-3 rounded mb-4 text-center">
            {erro}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
              Email
            </label>
            <input
              type="email"
              id="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full p-3 border rounded focus:outline-none focus:ring-2 focus:ring-orange-500"
            />
          </div>

          <div>
            <label htmlFor="senha" className="block text-sm font-medium text-gray-700 mb-1">
              Senha
            </label>
            <input
              type="password"
              id="senha"
              value={senha}
              onChange={(e) => setSenha(e.target.value)}
              required
              className="w-full p-3 border rounded focus:outline-none focus:ring-2 focus:ring-orange-500"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-orange-600 text-white py-3 rounded hover:bg-orange-700 transition"
          >
            Entrar
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
