"use client"

import { useEffect, useState, useRef } from "react"
import { colors } from "@/styles/colors"
import Cookie from "js-cookie"
import { Bell, ChevronDown, Menu, Search, Settings, User } from 'lucide-react'
import FazendaInfo from "./FazendaInfo"
import { useRouter } from "next/navigation"


const Header = ({ toggleSidebar }: { toggleSidebar?: () => void }) => {
  const [nomeUsuario, setNomeUsuario] = useState<string>("Usuário")
  const [showUserMenu, setShowUserMenu] = useState(false)
  const router = useRouter()
  const userMenuRef = useRef<HTMLDivElement>(null)
  const [tipoUsuarioLabel, setTipoUsuarioLabel] = useState<string>("");

  useEffect(() => {
    const userCookie = Cookie.get("user")
    if (userCookie) {
      try {
        const user = JSON.parse(userCookie)
        setNomeUsuario(user.nome || "Usuário")
        setTipoUsuarioLabel(user.tipoUsuario?.descricao || "Tipo desconhecido");
      } catch {
        setNomeUsuario("Usuário")
        setTipoUsuarioLabel("Tipo desconhecido");
      }
    }

    // Fechar menus ao clicar fora
    const handleClickOutside = (event: MouseEvent) => {
      if (userMenuRef.current && !userMenuRef.current.contains(event.target as Node)) {
        setShowUserMenu(false)
      }
    }    
    document.addEventListener("click", handleClickOutside)
    return () => document.removeEventListener("click", handleClickOutside)
  }, [])

  const handleUserMenuToggle = (e: React.MouseEvent) => {
    e.stopPropagation()
    setShowUserMenu(!showUserMenu)
  }

  const handleNotificationsToggle = (e: React.MouseEvent) => {
    e.stopPropagation()
    setShowUserMenu(false)
  }

  return (
    <header className="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-10">
      <div className="flex items-center justify-between px-4 py-3">
        {/* Esquerda: Botão de menu e pesquisa */}
        <div className="flex items-center gap-4">
          <button
            onClick={toggleSidebar}
            className="p-2 rounded-full hover:bg-gray-100 lg:hidden transition-colors"
            aria-label="Toggle sidebar"
          >
            <Menu size={20} />
          </button>
        </div>

        {/* Centro: Informações da Fazenda */}
        <div className="flex-1 flex justify-center">
          <FazendaInfo />
        </div>

        {/* Direita: Notificações e Perfil */}
        <div className="flex items-center gap-2" ref={userMenuRef}>
          {/* Perfil do usuário */}
          <div className="relative">
            <button
              onClick={handleUserMenuToggle}
              className="flex items-center gap-2 py-1 px-2 rounded-full hover:bg-gray-100 transition-colors"
            >
              <div className="w-8 h-8 rounded-full bg-orange-500 flex items-center justify-center text-white font-medium">
                {nomeUsuario.charAt(0).toUpperCase()}
              </div>
              <span className="hidden md:block text-sm font-medium text-gray-700">{nomeUsuario}</span>
              <ChevronDown size={16} className="hidden md:block text-gray-500" />
            </button>

            {/* Menu do usuário */}
            {showUserMenu && (
              <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-1 z-20">
                <div className="px-4 py-2 border-b border-gray-100">
                  <p className="text-sm font-medium text-gray-800">{nomeUsuario}</p>
                  <p className="text-xs text-gray-500">{tipoUsuarioLabel}</p>
                </div>
                {/* So mostra essa opção se o usuario for dono */}
                {tipoUsuarioLabel === "Dono" && (
                  <>
                    <button
                      onClick={() => {
                        const userCookie = Cookie.get("user");
                        const userId = userCookie ? JSON.parse(userCookie).id : null;
                        if (userId) {
                          router.push(`/perfil?mode=edit&userId=${userId}`);
                        } else {
                          console.error("User ID not found");
                        }
                      }}
                      className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-2"
                    >
                      <User size={16} />
                      Meu Perfil
                    </button>
                    <div className="border-t border-gray-100 my-1"></div>
                  </>
                )}
                <button
                  onClick={() => {
                    Cookie.remove("accessToken")
                    Cookie.remove("refreshToken")
                    Cookie.remove("user")
                    Cookie.remove("selectedFarmId")
                    router.push("/login")
                  }}
                  className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-50"
                >
                  Sair
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  )
}

export default Header
