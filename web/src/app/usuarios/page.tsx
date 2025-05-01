"use client"

import type React from "react"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import apiClient from "@/apiClient"
import {
  User,
  UserPlus,
  Search,
  Edit,
  Trash2,
  ChevronLeft,
  ChevronRight,
  Filter,
  RefreshCw,
  UserCog,
  CheckCircle,
  AlertCircle,
  ChevronDown,
} from "lucide-react"

interface Usuario {
  id: number
  nome: string
  email: string
  tipoUsuario?: {
    id: number
    descricao: string
  }
  created_at: string
}

interface TipoUsuario {
  id: number
  descricao: string
}

const UsuariosPage = () => {
  const router = useRouter()
  const [usuarios, setUsuarios] = useState<Usuario[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState("")
  const [tiposUsuario, setTiposUsuario] = useState<TipoUsuario[]>([])
  const [filtroTipoUsuario, setFiltroTipoUsuario] = useState<number | "">("")
  const [currentPage, setCurrentPage] = useState(1)
  const [totalPages, setTotalPages] = useState(1)
  const [itemsPerPage] = useState(10)
  const [notification, setNotification] = useState<{
    type: "success" | "error"
    message: string
  } | null>(null)
  const [usuarioParaExcluir, setUsuarioParaExcluir] = useState<Usuario | null>(null)
  const [showDeleteModal, setShowDeleteModal] = useState(false)
  const [deleting, setDeleting] = useState(false)

  const fetchUsuarios = async () => {
    setLoading(true)
    try {
      // Em um ambiente real, você usaria paginação e filtros na API
      const response = await apiClient.get("/usuarios")
      setUsuarios(response.data)

      // Simulando paginação no cliente
      const totalItems = response.data.length
      setTotalPages(Math.ceil(totalItems / itemsPerPage))
    } catch (error) {
      console.error("Erro ao buscar usuários:", error)
      setNotification({
        type: "error",
        message: "Não foi possível carregar a lista de usuários",
      })
    } finally {
      setLoading(false)
    }
  }

  const fetchTiposUsuario = async () => {
    try {
      const response = await apiClient.get("/tiposusuario")
      setTiposUsuario(response.data)
    } catch (error) {
      console.error("Erro ao buscar tipos de usuário:", error)
    }
  }

  useEffect(() => {
    fetchUsuarios()
    fetchTiposUsuario()
  }, [])

  // Limpar notificação após 5 segundos
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null)
      }, 5000)
      return () => clearTimeout(timer)
    }
  }, [notification])

  const handleSearch = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(e.target.value)
    setCurrentPage(1) // Reset para a primeira página ao pesquisar
  }

  const handleFilterChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setFiltroTipoUsuario(e.target.value === "" ? "" : Number(e.target.value))
    setCurrentPage(1) // Reset para a primeira página ao filtrar
  }

  const handlePageChange = (page: number) => {
    setCurrentPage(page)
  }

  const handleAddUser = () => {
    router.push("/perfil?mode=create")
  }

  const handleEditUser = (id: number) => {
    router.push(`/perfil?mode=edit&userId=${id}`)
  }

  const confirmDelete = (usuario: Usuario) => {
    setUsuarioParaExcluir(usuario)
    setShowDeleteModal(true)
  }

  const handleDeleteUser = async () => {
    if (!usuarioParaExcluir) return

    setDeleting(true)
    try {
      await apiClient.delete(`/usuarios/${usuarioParaExcluir.id}`)
      setNotification({
        type: "success",
        message: `Usuário ${usuarioParaExcluir.nome} excluído com sucesso!`,
      })
      fetchUsuarios() // Recarregar a lista
    } catch (error) {
      console.error("Erro ao excluir usuário:", error)
      setNotification({
        type: "error",
        message: "Não foi possível excluir o usuário",
      })
    } finally {
      setDeleting(false)
      setShowDeleteModal(false)
      setUsuarioParaExcluir(null)
    }
  }

  const cancelDelete = () => {
    setShowDeleteModal(false)
    setUsuarioParaExcluir(null)
  }

  // Filtrar usuários
  const filteredUsuarios = usuarios.filter((usuario) => {
    const matchesSearch =
      usuario.nome.toLowerCase().includes(searchTerm.toLowerCase()) ||
      usuario.email.toLowerCase().includes(searchTerm.toLowerCase())

    const matchesTipo = filtroTipoUsuario === "" || usuario.tipoUsuario?.id === filtroTipoUsuario

    return matchesSearch && matchesTipo
  })

  // Paginação
  const indexOfLastItem = currentPage * itemsPerPage
  const indexOfFirstItem = indexOfLastItem - itemsPerPage
  const currentUsuarios = filteredUsuarios.slice(indexOfFirstItem, indexOfLastItem)

  // Formatar data
  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    }).format(date)
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8 px-4">
      <div className="max-w-7xl mx-auto">
        {/* Cabeçalho */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
          <div>
            <h1 className="text-3xl font-bold text-gray-800 flex items-center gap-2">
              <UserCog className="text-orange-500" />
              Usuários
            </h1>
            <p className="text-gray-600 mt-1">Gerencie os usuários do sistema</p>
          </div>
          <button
            onClick={handleAddUser}
            className="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition-colors flex items-center gap-2"
          >
            <UserPlus size={18} />
            Novo Usuário
          </button>
        </div>

        {/* Notificação */}
        {notification && (
          <div
            className={`mb-6 p-4 rounded-lg flex items-start gap-3 ${
              notification.type === "success" ? "bg-green-50 text-green-800" : "bg-red-50 text-red-800"
            }`}
          >
            {notification.type === "success" ? (
              <CheckCircle className="w-5 h-5 mt-0.5 flex-shrink-0" />
            ) : (
              <AlertCircle className="w-5 h-5 mt-0.5 flex-shrink-0" />
            )}
            <div>
              <p className="font-medium">{notification.message}</p>
            </div>
          </div>
        )}

        {/* Filtros e Pesquisa */}
        <div className="bg-white rounded-xl shadow-sm mb-6 p-4">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Search size={18} className="text-gray-400" />
              </div>
              <input
                type="text"
                placeholder="Buscar por nome ou email..."
                value={searchTerm}
                onChange={handleSearch}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500"
              />
            </div>
            <div className="md:w-64">
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Filter size={18} className="text-gray-400" />
                </div>
                <select
                  value={filtroTipoUsuario}
                  onChange={handleFilterChange}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 appearance-none bg-white"
                >
                  <option value="">Todos os tipos</option>
                  {tiposUsuario.map((tipo) => (
                    <option key={tipo.id} value={tipo.id}>
                      {tipo.descricao}
                    </option>
                  ))}
                </select>
                <div className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                  <ChevronDown size={16} className="text-gray-500" />
                </div>
              </div>
            </div>
            <button
              onClick={() => fetchUsuarios()}
              className="md:w-auto px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors flex items-center justify-center gap-2"
            >
              <RefreshCw size={18} />
              Atualizar
            </button>
          </div>
        </div>

        {/* Tabela de Usuários */}
        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Nome
                  </th>
                  <th
                    scope="col"
                    className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Email
                  </th>
                  <th
                    scope="col"
                    className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Tipo
                  </th>
                  <th
                    scope="col"
                    className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Data de Cadastro
                  </th>
                  <th
                    scope="col"
                    className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Ações
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {loading ? (
                  <tr>
                    <td colSpan={5} className="px-6 py-4 text-center text-sm text-gray-500">
                      <div className="flex items-center justify-center">
                        <div className="w-6 h-6 border-2 border-orange-500 border-t-transparent rounded-full animate-spin mr-2"></div>
                        Carregando usuários...
                      </div>
                    </td>
                  </tr>
                ) : currentUsuarios.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="px-6 py-4 text-center text-sm text-gray-500">
                      Nenhum usuário encontrado
                    </td>
                  </tr>
                ) : (
                  currentUsuarios.map((usuario) => (
                    <tr key={usuario.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <div className="flex-shrink-0 h-10 w-10 bg-orange-100 rounded-full flex items-center justify-center">
                            <User className="h-5 w-5 text-orange-500" />
                          </div>
                          <div className="ml-4">
                            <div className="text-sm font-medium text-gray-900">{usuario.nome}</div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{usuario.email}</td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                          {usuario.tipoUsuario?.descricao || "Não definido"}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {usuario.created_at ? formatDate(usuario.created_at) : "N/A"}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <div className="flex justify-end gap-2">
                          <button
                            onClick={() => handleEditUser(usuario.id)}
                            className="text-blue-600 hover:text-blue-900 p-1 rounded-full hover:bg-blue-50"
                            title="Editar"
                          >
                            <Edit size={18} />
                          </button>
                          <button
                            onClick={() => confirmDelete(usuario)}
                            className="text-red-600 hover:text-red-900 p-1 rounded-full hover:bg-red-50"
                            title="Excluir"
                          >
                            <Trash2 size={18} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

          {/* Paginação */}
          {!loading && filteredUsuarios.length > 0 && (
            <div className="px-6 py-4 flex items-center justify-between border-t border-gray-200">
              <div className="text-sm text-gray-700">
                Mostrando <span className="font-medium">{indexOfFirstItem + 1}</span> a{" "}
                <span className="font-medium">{Math.min(indexOfLastItem, filteredUsuarios.length)}</span> de{" "}
                <span className="font-medium">{filteredUsuarios.length}</span> resultados
              </div>
              <div className="flex gap-2">
                <button
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
                  className={`px-3 py-1 rounded-md ${
                    currentPage === 1
                      ? "bg-gray-100 text-gray-400 cursor-not-allowed"
                      : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                  }`}
                >
                  <ChevronLeft size={18} />
                </button>
                {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
                  <button
                    key={page}
                    onClick={() => handlePageChange(page)}
                    className={`px-3 py-1 rounded-md ${
                      currentPage === page ? "bg-orange-500 text-white" : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                    }`}
                  >
                    {page}
                  </button>
                ))}
                <button
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPages}
                  className={`px-3 py-1 rounded-md ${
                    currentPage === totalPages
                      ? "bg-gray-100 text-gray-400 cursor-not-allowed"
                      : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                  }`}
                >
                  <ChevronRight size={18} />
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Modal de Confirmação de Exclusão */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
            <div className="text-center mb-4">
              <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
                <AlertCircle className="h-6 w-6 text-red-600" />
              </div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Confirmar exclusão</h3>
              <p className="text-sm text-gray-500">
                Tem certeza que deseja excluir o usuário{" "}
                <span className="font-semibold">{usuarioParaExcluir?.nome}</span>? Esta ação não pode ser desfeita.
              </p>
            </div>
            <div className="flex justify-end gap-3 mt-6">
              <button
                onClick={cancelDelete}
                className="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
              >
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default UsuariosPage
