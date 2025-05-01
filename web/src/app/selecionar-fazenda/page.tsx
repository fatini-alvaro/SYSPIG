'use client';

import { Building2, LogOut, MapPin, Search } from "lucide-react"
import Image from "next/image"
import { logo } from "@/assets/logos"
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Cookie from 'js-cookie';
import apiClient from '../../apiClient';
import { Fazenda } from '../../models/Fazenda';
import { logout } from '@/services/logout';

const SelecionarFazendaPage = () => {
  const router = useRouter()
  const [fazendas, setFazendas] = useState<Fazenda[]>([])
  const [filteredFazendas, setFilteredFazendas] = useState<Fazenda[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState("")
  const [userName, setUserName] = useState("")

  useEffect(() => {
    const userCookie = Cookie.get("user")

    if (!userCookie || userCookie === "undefined") {
      logout(router)
      return
    }

    try {
      const user = JSON.parse(userCookie)
      setUserName(user.nome || "Usuário")

      // Função para buscar as fazendas
      const fetchFazendas = async () => {
        try {
          const response = await apiClient.get(`/usuariofazendas/${user.id}`)
          setFazendas(response.data)
          setFilteredFazendas(response.data)
        } catch (error) {
          console.error("Erro ao buscar fazendas:", error)
        } finally {
          setLoading(false)
        }
      }

      fetchFazendas() // Chama a função de busca
    } catch (error) {
      console.error("Erro ao parsear o cookie do usuário:", error)
      logout(router)
    }
  }, [router])

  useEffect(() => {
    if (searchTerm.trim() === "") {
      setFilteredFazendas(fazendas)
    } else {
      const filtered = fazendas.filter((fazenda) => fazenda.nome.toLowerCase().includes(searchTerm.toLowerCase()))
      setFilteredFazendas(filtered)
    }
  }, [searchTerm, fazendas])

  const handleSelecionarFazenda = (fazendaId: number) => {
    const fazendaSelecionada = fazendas.find((f) => f.id === fazendaId)
    if (fazendaSelecionada) {
      Cookie.set("selectedFarmId", fazendaId.toString(), { expires: 1 })
      Cookie.set("selectedFarmName", fazendaSelecionada.nome, { expires: 1 })
      router.push("/")
    }
  }

  const handleLogout = () => {
    logout(router)
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="w-16 h-16 mx-auto border-4 border-orange-500 border-t-transparent rounded-full animate-spin mb-4"></div>
          <p className="text-gray-600 font-medium">Carregando fazendas...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Header */}
      <header className="bg-white shadow-sm py-4 px-6 flex justify-between items-center">
        <div className="flex items-center">
          <Image src={logo || "/placeholder.svg"} alt="Logo" width={120} height={40} priority />
        </div>
        <div className="flex items-center gap-4">
          <div className="text-right">
            <p className="text-sm text-gray-600">Olá,</p>
            <p className="font-medium text-gray-800">{userName}</p>
          </div>
          <button
            onClick={handleLogout}
            className="p-2 text-gray-600 hover:text-red-600 rounded-full hover:bg-red-50 transition-colors"
            title="Sair"
          >
            <LogOut size={20} />
          </button>
        </div>
      </header>

      <div className="flex-1 container mx-auto max-w-5xl px-4 py-8">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-800 mb-2">Selecione uma Fazenda</h1>
          <p className="text-gray-600 max-w-2xl mx-auto">
            Escolha uma das fazendas disponíveis para acessar o sistema de gestão
          </p>
        </div>

        {/* Barra de pesquisa */}
        <div className="max-w-md mx-auto mb-8">
          <div className="relative">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search size={18} className="text-gray-400" />
            </div>
            <input
              type="text"
              placeholder="Buscar fazenda..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-3 bg-white text-black border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors"
            />
          </div>
        </div>

        {filteredFazendas.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-lg shadow-sm border border-gray-200">
            <Building2 size={48} className="mx-auto text-gray-400 mb-4" />
            <h2 className="text-xl font-semibold text-gray-700 mb-2">Nenhuma fazenda encontrada</h2>
            <p className="text-gray-500">
              {searchTerm
                ? "Nenhuma fazenda corresponde à sua busca. Tente outro termo."
                : "Você não possui acesso a nenhuma fazenda. Entre em contato com o suporte."}
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredFazendas.map((fazenda) => (
              <div
                key={fazenda.id}
                onClick={() => handleSelecionarFazenda(fazenda.id)}
                className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-all duration-300 cursor-pointer group"
              >
                <div className="h-24 bg-gradient-to-r from-orange-500 to-orange-600 relative">
                  <div className="absolute bottom-0 right-0 w-24 h-24 opacity-10">
                    <Building2 size={96} className="text-white" />
                  </div>
                </div>
                <div className="p-6 pt-5 relative">
                  <div className="absolute -top-8 left-6 bg-white rounded-full p-3 shadow-md border border-gray-100">
                    <Building2 size={32} className="text-orange-500" />
                  </div>
                  <div className="ml-12">
                    <h2 className="text-xl font-bold text-gray-800 mb-2 group-hover:text-orange-600 transition-colors">
                      {fazenda.nome}
                    </h2>
                    {fazenda.cidade && (
                      <div className="flex items-center text-gray-600">
                        <MapPin size={16} className="mr-1 flex-shrink-0" />
                        <span>
                          {fazenda.cidade.nome} - {fazenda.cidade.uf?.sigla}
                        </span>
                      </div>
                    )}
                  </div>
                  <div className="mt-4 pt-4 border-t border-gray-100 flex justify-end">
                    <span className="text-sm font-medium text-orange-600 group-hover:translate-x-1 transition-transform inline-flex items-center">
                      Selecionar
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        className="h-4 w-4 ml-1"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                      </svg>
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-200 py-4 px-6 text-center text-gray-500 text-sm">
        © 2025 SYSPIG. Todos os direitos reservados.
      </footer>
    </div>
  );
};

export default SelecionarFazendaPage;
