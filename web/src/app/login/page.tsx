'use client';

import type React from "react"

import Image from "next/image"
import { Eye, EyeOff, Lock, Mail } from "lucide-react"
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Cookie from 'js-cookie';
import apiClient from '../../apiClient';
import { LoginResponse } from '../../models/LoginResponse';
import { logo } from '../../assets/logos';
import { AxiosError } from "axios";

const LoginPage = () => {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [erro, setErro] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false)

  useEffect(() => {
    const token = Cookie.get('accessToken');
    if (token) {
      router.replace('/');
    }
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setErro(null)
    setLoading(true)
    try {
      const response = await apiClient.post<LoginResponse>("/auth", { email, senha })
      const data = response.data

      Cookie.set("accessToken", data.accessToken, { expires: 1 })
      Cookie.set("refreshToken", data.refreshToken, { expires: 7 })
      Cookie.set("user", JSON.stringify(data.usuario), { expires: 1 })

      router.push("/selecionar-fazenda")
    } catch (error: AxiosError | unknown) {
      if (error instanceof AxiosError) {
        setErro(error.response?.data?.message || "Erro ao fazer login");
      } else {
        setErro("Erro ao fazer login");
      }
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      <div className="hidden md:flex md:w-1/2 bg-gradient-to-br from-orange-500 to-orange-600 text-white p-8 flex-col justify-between">
        <div className="max-w-md mx-auto flex flex-col h-full justify-center">
          <h1 className="text-4xl font-bold mb-6">Bem-vindo ao SYSPIG</h1>
          <p className="text-xl mb-8">Sistema de gestão para suinocultura que simplifica o controle da sua fazenda.</p>

          <div className="space-y-6">
            <div className="flex items-start space-x-4">
              <div className="bg-white/20 p-2 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <div>
                <h3 className="font-semibold text-lg">Gestão Completa</h3>
                <p className="text-white/80">Controle todo o ciclo de produção da sua fazenda</p>
              </div>
            </div>

            <div className="flex items-start space-x-4">
              <div className="bg-white/20 p-2 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                  />
                </svg>
              </div>
              <div>
                <h3 className="font-semibold text-lg">Relatórios Detalhados</h3>
                <p className="text-white/80">Visualize dados e métricas importantes para tomada de decisão</p>
              </div>
            </div>

            <div className="flex items-start space-x-4">
              <div className="bg-white/20 p-2 rounded-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"
                  />
                </svg>
              </div>
              <div>
                <h3 className="font-semibold text-lg">Acesso em Qualquer Dispositivo</h3>
                <p className="text-white/80">Utilize no campo ou no escritório, em qualquer dispositivo</p>
              </div>
            </div>
          </div>
        </div>

        <div className="text-sm text-white/70 mt-8">© 2025 SYSPIG. Todos os direitos reservados.</div>
      </div>

      <div className="flex-1 flex items-center justify-center p-8 bg-gray-50">
        <div className="w-full max-w-md">
          <div className="text-center mb-8">
            <Image src={logo || "/placeholder.svg"} alt="Logo" width={260} height={120} className="mx-auto" priority />
            <h2 className="text-2xl font-bold text-gray-800 mt-6">Acesse sua conta</h2>
            <p className="text-gray-600 mt-2">Entre com suas credenciais para continuar</p>
          </div>

          {erro && (
            <div className="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-md">
              <div className="flex">
                <div className="flex-shrink-0">
                  <svg className="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fillRule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                      clipRule="evenodd"
                    />
                  </svg>
                </div>
                <div className="ml-3">
                  <p className="text-sm text-red-700">{erro}</p>
                </div>
              </div>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
                Email
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Mail size={18} className="text-gray-400" />
                </div>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full pl-10 pr-3 py-3 text-gray-700 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors"
                  placeholder="seu@email.com"
                />
              </div>
            </div>

            <div>
              <label htmlFor="senha" className="block text-sm font-medium text-gray-700 mb-1">
                Senha
              </label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Lock size={18} className="text-gray-400" />
                </div>
                <input
                  id="senha"
                  type={showPassword ? "text" : "password"}
                  value={senha}
                  onChange={(e) => setSenha(e.target.value)}
                  required
                  className="w-full pl-10 pr-10 py-3 text-gray-700 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  className="absolute inset-y-0 right-0 pr-3 flex items-center"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? (
                    <EyeOff size={18} className="text-gray-400 hover:text-gray-600" />
                  ) : (
                    <Eye size={18} className="text-gray-400 hover:text-gray-600" />
                  )}
                </button>
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div className="text-sm">
                <a href="#" className="font-medium text-orange-600 hover:text-orange-500">
                  Esqueceu a senha?
                </a>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className={`w-full flex justify-center items-center gap-2 bg-orange-600 text-white py-3 px-4 rounded-lg transition-colors ${
                loading ? "opacity-70 cursor-not-allowed" : "hover:bg-orange-700"
              }`}
            >
              {loading ? (
                <>
                  <svg className="animate-spin h-5 w-5 text-white" viewBox="0 0 24 24">
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    ></circle>
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                    ></path>
                  </svg>
                  Entrando...
                </>
              ) : (
                "Entrar"
              )}
            </button>
          </form>

          <div className="mt-8 text-center">
            <p className="text-sm text-gray-600">
              Precisa de ajuda?{" "}
              <a href="#" className="font-medium text-orange-600 hover:text-orange-500">
                Entre em contato com o suporte
              </a>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
