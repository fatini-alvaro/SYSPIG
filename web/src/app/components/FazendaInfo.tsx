"use client"

import type React from "react"
import { useEffect, useRef, useState } from "react"
import { Building2, ChevronDown, MapPin } from "lucide-react"
import { useRouter } from "next/navigation"
import Cookie from "js-cookie"

const FazendaInfo = () => {
  const [nomeFazenda, setNomeFazenda] = useState<string>("Fazenda")
  const [showMenu, setShowMenu] = useState(false)
  const router = useRouter()
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const fazendaNome = Cookie.get("selectedFarmName")
    if (fazendaNome) {
      setNomeFazenda(fazendaNome)
    }

    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setShowMenu(false)
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
    return () => {
      document.removeEventListener("mousedown", handleClickOutside)
    }
  }, [])

  const handleTrocarFazenda = () => {
    router.push("/selecionar-fazenda")
  }

  const handleMenuToggle = (e: React.MouseEvent) => {
    e.stopPropagation()
    setShowMenu((prev) => !prev)
  }

  return (
    <div className="relative" ref={menuRef}>
      <button
        onClick={handleMenuToggle}
        className="flex items-center gap-2 py-1.5 px-3 rounded-full bg-orange-50 hover:bg-orange-100 transition-colors"
      >
        <Building2 size={18} className="text-orange-500" />
        <span className="font-medium text-gray-800">{nomeFazenda}</span>
        <ChevronDown size={16} className="text-gray-500" />
      </button>

      {showMenu && (
        <div className="absolute top-full mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-20">
          <div className="px-4 py-2 border-b border-gray-100">
            <h3 className="font-semibold text-gray-800">Fazenda Atual</h3>
            <div className="flex items-center gap-1 mt-1">
              <MapPin size={14} className="text-gray-500" />
              <p className="text-xs text-gray-500">{nomeFazenda}</p>
            </div>
          </div>
          <div className="px-4 py-2">
            <button
              onClick={handleTrocarFazenda}
              className="w-full bg-orange-500 hover:bg-orange-600 text-white py-2 px-4 rounded text-sm font-medium transition-colors"
            >
              Trocar de Fazenda
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

export default FazendaInfo
