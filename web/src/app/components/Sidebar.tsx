"use client"

import type React from "react"
import { useState, useEffect } from "react"
import { useRouter, usePathname } from "next/navigation"
import Cookie from "js-cookie"
import { logoWhite } from "@/assets/logos"
import { logout } from "@/services/logout"
import Image from "next/image"
import {
  ChevronDown,
  LayoutDashboard,
  LogOut,
  Menu,
  Users,
  X,
} from "lucide-react"

interface NavItemProps {
  icon: React.ReactNode
  label: string
  href?: string
  active?: boolean
  subItems?: { label: string; href: string }[]
}

const NavItem = ({ icon, label, href = "#", active = false, subItems }: NavItemProps) => {
  const router = useRouter()
  const [isOpen, setIsOpen] = useState(false)

  const hasSubItems = subItems && subItems.length > 0

  const handleClick = () => {
    if (hasSubItems) {
      setIsOpen(!isOpen)
    } else {
      router.push(href)
    }
  }

  return (
    <div className="mb-1">
      <button
        onClick={handleClick}
        className={`w-full flex items-center justify-between px-3 py-2.5 rounded-lg transition-colors ${
          active ? "bg-orange-500 text-white font-medium" : "text-white/90 hover:bg-white/10 hover:text-white"
        }`}
      >
        <div className="flex items-center gap-3">
          {icon}
          <span className="text-sm">{label}</span>
        </div>
        {hasSubItems && (
          <ChevronDown size={16} className={`transition-transform ${isOpen ? "transform rotate-180" : ""}`} />
        )}
      </button>

      {/* Subitems */}
      {hasSubItems && isOpen && (
        <div className="mt-1 ml-9 space-y-1">
          {subItems.map((item, index) => (
            <button
              key={index}
              onClick={() => router.push(item.href)}
              className="w-full text-left text-sm py-2 px-3 rounded-lg text-white/80 hover:text-white hover:bg-white/10 transition-colors"
            >
              {item.label}
            </button>
          ))}
        </div>
      )}
    </div>
  )
}

const Sidebar = () => {
  const router = useRouter()
  const pathname = usePathname()
  const [isMobileOpen, setIsMobileOpen] = useState(false)
  const [userName, setUserName] = useState("Usuário")
  const [tipoUsuarioLabel, setTipoUsuarioLabel] = useState<string>("")

  useEffect(() => {
    const userCookie = Cookie.get("user")
    if (userCookie) {
      try {
        const user = JSON.parse(userCookie)
        setUserName(user.nome || "Usuário")
        setTipoUsuarioLabel(user.tipoUsuario?.descricao || "Tipo desconhecido")
      } catch {
        setUserName("Usuário")
        setTipoUsuarioLabel("Tipo desconhecido")
      }
    }

    // Adicionar listener para redimensionamento da janela
    const handleResize = () => {
      if (window.innerWidth >= 1024) {
        setIsMobileOpen(false)
      }
    }

    window.addEventListener("resize", handleResize)
    return () => {
      window.removeEventListener("resize", handleResize)
    }
  }, [])

  const handleLogout = () => {
    logout(router)
  }

  const toggleSidebar = () => {
    setIsMobileOpen(!isMobileOpen)
  }

  return (
    <>
      {/* Overlay para mobile */}
      {isMobileOpen && (
        <div className="fixed inset-0 bg-black/50 z-20 lg:hidden" onClick={() => setIsMobileOpen(false)}></div>
      )}

      {/* Botão de toggle para mobile */}
      <button
        onClick={toggleSidebar}
        className="fixed bottom-4 right-4 z-30 lg:hidden bg-orange-600 text-white p-3 rounded-full shadow-lg border-2 border-white"
        aria-label="Toggle sidebar"
      >
        {isMobileOpen ? <X size={24} /> : <Menu size={24} />}
      </button>

      {/* Sidebar */}
      <aside
        className={`fixed inset-y-0 left-0 z-30 w-64 bg-gradient-to-b from-orange-600 to-orange-500 transform transition-transform duration-300 ease-in-out lg:translate-x-0 ${
          isMobileOpen ? "translate-x-0" : "-translate-x-full"
        } lg:relative lg:translate-x-0`}
      >
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="p-4 flex items-center justify-center border-b border-orange-400/30">
            <Image
              src={logoWhite || "/placeholder.svg"}
              alt="Logo SYSPIG"
              width={140}
              height={50}
              className="object-contain"
            />
          </div>

          {/* Perfil do usuário */}
          <div className="px-4 py-4 border-b border-orange-400/30">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center text-white font-bold">
                {userName.charAt(0).toUpperCase()}
              </div>
              <div>
                <h3 className="text-white font-medium text-sm">{userName}</h3>
                <p className="text-white/70 text-xs">{tipoUsuarioLabel}</p>
              </div>
            </div>
          </div>

          {/* Navegação */}
          <nav className="flex-1 px-3 py-4 overflow-y-auto scrollbar-thin scrollbar-thumb-orange-400/30 scrollbar-track-transparent">
            <div className="mb-4">
              <p className="px-3 text-xs font-medium text-white/50 uppercase tracking-wider mb-2">Principal</p>
              <NavItem
                icon={<LayoutDashboard size={18} />}
                label="Dashboard"
                href="/dashboard"
                active={pathname === "/dashboard"}
              />
            </div>

            <div className="mb-4">
              <p className="px-3 text-xs font-medium text-white/50 uppercase tracking-wider mb-2">Gestão</p>
              {tipoUsuarioLabel === "Dono" && (                 
                  <NavItem icon={<Users size={18} />} label="Usuários" href="/usuarios" active={pathname === "/usuarios"} />
                )}
              {/* <NavItem
                icon={<ClipboardList size={18} />}
                label="Relatórios"
                href="/relatorios"
                active={pathname === "/relatorios"}
              /> */}
            </div>
          </nav>

          {/* Botão de logout */}
          <div className="p-4 border-t border-orange-400/30">
            <button
              onClick={handleLogout}
              className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-white hover:bg-white/10 transition-colors"
            >
              <LogOut size={18} />
              <span className="text-sm font-medium">Sair</span>
            </button>
          </div>
        </div>
      </aside>
    </>
  )
}

export default Sidebar
