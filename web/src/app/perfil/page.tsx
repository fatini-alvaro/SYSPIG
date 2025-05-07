"use client"

import type React from "react"

import { useState, useEffect, useCallback, Suspense } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import Cookie from "js-cookie"
import apiClient from "@/apiClient"
import { User, Mail, Plus, Lock, Building2, Calendar, Save, X, CheckCircle2, AlertCircle, Eye, EyeOff, UserCog, Clock, ArrowLeft, ChevronDown, Search, Trash2 } from 'lucide-react'
import { AxiosError } from "axios"

interface UserProfile {
  id: number
  nome: string
  email: string
  tipoUsuario?: {
    id: number
    descricao: string
  }
  created_at: string
  updated_at: string
  usuarioFazendas?: Array<{
    id: number
    fazenda: {
      id: number
      nome: string
      cidade?: {
        nome: string
        uf?: {
          sigla: string
        }
      }
    }
  }>
}

interface Fazenda {
  id: number
  nome: string
  cidade?: {
    nome: string
    uf?: {
      sigla: string
    }
  }
}

interface TipoUsuario {
  id: number
  descricao: string
}

interface PasswordForm {
  senhaAtual: string
  novaSenha: string
  confirmarSenha: string
}

const PerfilPage = () => {
  const router = useRouter()
  const searchParams = useSearchParams()
  
  // Determinar o modo da página com base nos parâmetros da URL
  const mode = searchParams.get("mode") || "view" // view, edit, create
  const userId = searchParams.get("userId") || null
  
  const isOwnProfile = !mode || mode === "view"
  const isEditing = mode === "edit"
  const isCreating = mode === "create"
  
  const pageTitle = isCreating ? "Novo Usuário" : isEditing ? "Editar Usuário" : "Meu Perfil"

  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [editMode, setEditMode] = useState(isEditing || isCreating)
  const [editedProfile, setEditedProfile] = useState<{ 
    nome: string; 
    email: string;
    tipoUsuarioId?: number;
    senha?: string;
    confirmarSenha?: string;
  }>({
    nome: "",
    email: "",
    tipoUsuarioId: undefined,
    senha: "",
    confirmarSenha: "",
  })
  const [passwordForm, setPasswordForm] = useState<PasswordForm>({
    senhaAtual: "",
    novaSenha: "",
    confirmarSenha: "",
  })
  const [tiposUsuario, setTiposUsuario] = useState<TipoUsuario[]>([])
  const [showCurrentPassword, setShowCurrentPassword] = useState(false)
  const [showNewPassword, setShowNewPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmNewPassword, setShowConfirmNewPassword] = useState(false)
  const [availableFarms, setAvailableFarms] = useState<Fazenda[]>([])
  const [showAddFarmModal, setShowAddFarmModal] = useState(false)
  const [notification, setNotification] = useState<{
    type: "success" | "error"
    message: string
  } | null>(null)
  const [changingPassword, setChangingPassword] = useState(false)
  const [savingProfile, setSavingProfile] = useState(false)
  const [tipoUsuarioLabel, setTipoUsuarioLabel] = useState<string>("");
  const userLogadoCookie = Cookie.get("user")
  const userLogado = userLogadoCookie ? JSON.parse(userLogadoCookie) : null
  const [removingFarmId, setRemovingFarmId] = useState<number | null>(null)
  const [searchFarmTerm, setSearchFarmTerm] = useState("")
  const [addingFarm, setAddingFarm] = useState(false)

  const fetchAvailableFarms = useCallback(async () => {
    try {
      const response = await apiClient.get(`/fazendas/${userLogado.id}`);
      const allFarms = response.data;
      const userFarmIds = profile?.usuarioFazendas?.map(uf => uf.fazenda.id) || [];
      const availableFarmsFiltered = allFarms.filter((farm: Fazenda) => 
        !userFarmIds.includes(farm.id)
      );
      setAvailableFarms(availableFarmsFiltered);
    } catch (error) {
      console.error("Erro ao buscar fazendas disponíveis:", error);
      setNotification({
        type: "error",
        message: "Não foi possível carregar as fazendas disponíveis",
      });
    }
  }, [userLogado.id, profile?.usuarioFazendas]);
  
  const handleRemoveFarm = async (farmId: number) => {
    if (!profile) return

    setRemovingFarmId(farmId)
    try {
      // Find the usuarioFazenda entry to delete
      const usuarioFazenda = profile.usuarioFazendas?.find((uf) => uf.fazenda.id === farmId)
      if (!usuarioFazenda) {
        throw new Error("Relação usuário-fazenda não encontrada")
      }

      await apiClient.delete(`/usuariofazendas/${usuarioFazenda.id}`)

      // Update the profile to remove the farm
      if (profile) {
        const updatedProfile = { ...profile }
        const removedFarm = updatedProfile.usuarioFazendas?.find((uf) => uf.fazenda.id === farmId)?.fazenda

        updatedProfile.usuarioFazendas = updatedProfile.usuarioFazendas?.filter((uf) => uf.fazenda.id !== farmId) || []

        setProfile(updatedProfile)

        // Add the farm back to available farms if it exists
        if (removedFarm) {
          setAvailableFarms([...availableFarms, removedFarm])
        }
      }

      setNotification({
        type: "success",
        message: "Fazenda desvinculada com sucesso!",
      })
    } catch (error) {
      console.error("Erro ao desvincular fazenda:", error)
      setNotification({
        type: "error",
        message: "Não foi possível desvincular a fazenda",
      })
    } finally {
      setRemovingFarmId(null)
    }
  }

  const handleAddFarm = async (farmId: number) => {
    if (!profile) return

    setAddingFarm(true)
    try {
      await apiClient.post(`/usuariofazendas`, {
        usuarioId: profile.id,
        fazendaId: farmId,
      })

      // Update the profile to include the new farm
      const selectedFarm = availableFarms.find((farm) => farm.id === farmId)
      if (selectedFarm && profile) {
        const updatedProfile = { ...profile }
        updatedProfile.usuarioFazendas = [
          ...(updatedProfile.usuarioFazendas || []),
          {
            id: Date.now(), // Temporary ID until we refresh
            fazenda: selectedFarm,
          },
        ]
        setProfile(updatedProfile)

        // Remove the farm from available farms
        setAvailableFarms(availableFarms.filter((farm) => farm.id !== farmId))
      }

      setNotification({
        type: "success",
        message: "Fazenda adicionada com sucesso!",
      })
      setShowAddFarmModal(false)
    } catch (error) {
      console.error("Erro ao adicionar fazenda:", error)
      setNotification({
        type: "error",
        message: "Não foi possível adicionar a fazenda",
      })
    } finally {
      setAddingFarm(false)
    }
  }

  // Load tiposUsuario once on mount
  useEffect(() => {
    const tipos = [
      { id: 1, descricao: "Dono" },
      { id: 2, descricao: "Funcionário" },
    ];
    setTiposUsuario(tipos);
  }, []);

  // Load profile when URL params change
  useEffect(() => {
    const fetchUserProfile = async () => {
      setLoading(true);
      try {
        let userData;
        
        if (isEditing && userId) {
          const response = await apiClient.get(`/usuarios/perfil/${userId}`);
          userData = response.data;
          setTipoUsuarioLabel(userData.tipoUsuario?.descricao || "Tipo desconhecido");
        }
        
        if (userData) {
          setProfile(userData);
          setEditedProfile({
            nome: userData.nome,
            email: userData.email,
            tipoUsuarioId: userData.tipoUsuario?.id,
          });
        } else if (isCreating) {
          setEditedProfile({
            nome: "",
            email: "",
            tipoUsuarioId: tiposUsuario.length > 0 ? tiposUsuario[0].id : undefined,
            senha: "",
            confirmarSenha: "",
          });
        }
      } catch (error) {
        console.error("Erro ao buscar perfil do usuário:", error);
        setNotification({
          type: "error",
          message: "Não foi possível carregar os dados do perfil",
        });
      } finally {
        setLoading(false);
      }
    };

    fetchUserProfile();
  }, [isEditing, isCreating, userId, tiposUsuario]);

  // Load farms when profile changes
  useEffect(() => {
    if (!profile) return;

    const fetchAvailableFarms = async () => {
      try {
        const response = await apiClient.get(`/fazendas/${userLogado.id}`);
        const allFarms = response.data;
        const userFarmIds = profile.usuarioFazendas?.map(uf => uf.fazenda.id) || [];
        const availableFarmsFiltered = allFarms.filter((farm: Fazenda) => 
          !userFarmIds.includes(farm.id)
        );
        setAvailableFarms(availableFarmsFiltered);
      } catch (error) {
        console.error("Erro ao buscar fazendas disponíveis:", error);
        setNotification({
          type: "error",
          message: "Não foi possível carregar as fazendas disponíveis",
        });
      }
    };

    fetchAvailableFarms();
  }, [profile, userLogado.id]);

  // Limpar notificação após 5 segundos
  useEffect(() => {
    if (notification) {
      const timer = setTimeout(() => {
        setNotification(null)
      }, 5000)
      return () => clearTimeout(timer)
    }
  }, [notification])

  const handleEditToggle = () => {
    if (editMode && profile) {
      // Cancelar edição
      setEditedProfile({
        nome: profile.nome,
        email: profile.email,
        tipoUsuarioId: profile.tipoUsuario?.id,
      })
    }
    setEditMode(!editMode)
  }

  const handleProfileChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setEditedProfile((prev) => ({
      ...prev,
      [name]: name === "tipoUsuarioId" ? Number(value) : value,
    }))
  }

  const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target
    setPasswordForm((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  const validateForm = () => {
    if (!editedProfile.nome.trim()) {
      setNotification({
        type: "error",
        message: "O nome é obrigatório",
      })
      return false
    }

    if (!editedProfile.email.trim()) {
      setNotification({
        type: "error",
        message: "O email é obrigatório",
      })
      return false
    }

    // Validar formato de email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(editedProfile.email)) {
      setNotification({
        type: "error",
        message: "Formato de email inválido",
      })
      return false
    }

    if (isCreating || isEditing) {
      if (!editedProfile.tipoUsuarioId) {
        setNotification({
          type: "error",
          message: "O tipo de usuário é obrigatório",
        })
        return false
      }
    }

    // Validar senha apenas para criação
    if (isCreating) {
      if (!editedProfile.senha) {
        setNotification({
          type: "error",
          message: "A senha é obrigatória",
        })
        return false
      }

      if (editedProfile.senha.length < 6) {
        setNotification({
          type: "error",
          message: "A senha deve ter pelo menos 6 caracteres",
        })
        return false
      }

      if (editedProfile.senha !== editedProfile.confirmarSenha) {
        setNotification({
          type: "error",
          message: "As senhas não coincidem",
        })
        return false
      }
    }

    return true
  }

  const handleSaveProfile = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!validateForm()) return

    setSavingProfile(true)
    try {
      if (isCreating) {
        // Criar novo usuário
        const response = await apiClient.post("/usuarios", {
          nome: editedProfile.nome,
          email: editedProfile.email,
          tipoUsuarioId: editedProfile.tipoUsuarioId,
          senha: editedProfile.senha,
          criadoPor: userLogado.id,
        })
      
        const newUser = response.data
      
        setNotification({
          type: "success",
          message: "Usuário criado com sucesso!",
        })
      
        // Atualiza o estado local com o novo usuário
        setProfile(newUser)
      
        // Altera o modo de criação para edição
        setEditMode(true)
        router.replace(`/perfil?mode=edit&userId=${newUser.id}`)
      } else if (isEditing && userId) {
        // Atualizar usuário existente
        await apiClient.put(`/usuarios/${userId}`, {
          nome: editedProfile.nome,
          email: editedProfile.email,
        })

        setNotification({
          type: "success",
          message: "Usuário atualizado com sucesso!",
        })

        // Redirecionar após um breve delay
        setTimeout(() => {
          router.push("/usuarios")
        }, 2000)
      } 
      
      if (isOwnProfile ) {
        // Atualizar o cookie do usuário
        const userCookie = Cookie.get("user")
        if (userCookie) {
          const user = JSON.parse(userCookie)
          const updatedUser = {
            ...user,
            nome: editedProfile.nome,
            email: editedProfile.email,
          }
          Cookie.set("user", JSON.stringify(updatedUser), { expires: 1 })
        }

        setProfile((prev) => {
          if (!prev) return null
          return {
            ...prev,
            nome: editedProfile.nome,
            email: editedProfile.email,
          }
        })
      }
    } catch (error: unknown) {
      const axiosError = error as AxiosError<{ message: string }>;
      console.error("Erro ao salvar perfil:", axiosError);
      setNotification({
        type: "error",
        message: axiosError.response?.data?.message || "Erro ao salvar. Tente novamente.",
      });
    } finally {
      setSavingProfile(false)
    }
  }

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!profile) return

    // Validar senhas
    if (passwordForm.novaSenha !== passwordForm.confirmarSenha) {
      setNotification({
        type: "error",
        message: "A nova senha e a confirmação não coincidem",
      })
      return
    }

    if (passwordForm.novaSenha.length < 6) {
      setNotification({
        type: "error",
        message: "A nova senha deve ter pelo menos 6 caracteres",
      })
      return
    }

    setChangingPassword(true)
    try {
      await apiClient.post(`/usuarios/${userId}/change-password`, {
        senhaAtual: passwordForm.senhaAtual,
        novaSenha: passwordForm.novaSenha,
      })

      setNotification({
        type: "success",
        message: "Senha alterada com sucesso!",
      })

      // Limpar formulário
      setPasswordForm({
        senhaAtual: "",
        novaSenha: "",
        confirmarSenha: "",
      })
    } catch (error: unknown) {
      const axiosError = error as AxiosError<{ message: string }>;
      console.error("Erro ao alterar senha:", axiosError);
      setNotification({
        type: "error",
        message: axiosError.response?.data?.message || "Erro ao alterar senha. Tente novamente.",
      });
    } finally {
      setChangingPassword(false)
    }
  }

  const handleCancel = () => {
    router.push(isOwnProfile ? "/dashboard" : "/usuarios")
  }

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date)
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="w-16 h-16 mx-auto border-4 border-orange-500 border-t-transparent rounded-full animate-spin mb-4"></div>
          <p className="text-gray-600 font-medium">Carregando...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8 px-4">
      <div className="max-w-7xl mx-auto">
        {/* Cabeçalho */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
          <div>
            {(isEditing || isCreating) && (
              <button onClick={handleCancel} className="flex items-center text-gray-600 hover:text-orange-500 mb-2">
                <ArrowLeft size={18} className="mr-1" />
                <span>Voltar para lista</span>
              </button>
            )}
            <h1 className="text-3xl font-bold text-gray-800 flex items-center gap-2">
              <UserCog className="text-orange-500" />
              {pageTitle}
            </h1>
            <p className="text-gray-600 mt-1">
              {isCreating
                ? "Preencha os dados para criar um novo usuário"
                : isEditing
                ? "Atualize as informações do usuário"
                : "Visualize e edite suas informações pessoais"}
            </p>
          </div>
          {isOwnProfile && (
            <button
              onClick={handleEditToggle}
              className={`px-4 py-2 rounded-lg flex items-center gap-2 transition-colors ${
                editMode ? "bg-gray-200 text-gray-700 hover:bg-gray-300" : "bg-orange-500 text-white hover:bg-orange-600"
              }`}
            >
              {editMode ? (
                <>
                  <X size={18} /> Cancelar
                </>
              ) : (
                <>
                  <User size={18} /> Editar Perfil
                </>
              )}
            </button>
          )}
        </div>

        {/* Notificação */}
        {notification && (
          <div
            className={`mb-6 p-4 rounded-lg flex items-start gap-3 ${
              notification.type === "success" ? "bg-green-50 text-green-800" : "bg-red-50 text-red-800"
            }`}
          >
            {notification.type === "success" ? (
              <CheckCircle2 className="w-5 h-5 mt-0.5 flex-shrink-0" />
            ) : (
              <AlertCircle className="w-5 h-5 mt-0.5 flex-shrink-0" />
            )}
            <div>
              <p className="font-medium">{notification.message}</p>
            </div>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Coluna da esquerda - Informações do perfil */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-xl shadow-sm overflow-hidden">
              <div className="bg-gradient-to-r from-orange-500 to-orange-600 px-6 py-4">
                <h2 className="text-xl font-semibold text-white">Informações Pessoais</h2>
              </div>

              <div className="p-6">
                <form onSubmit={handleSaveProfile}>
                  <div className="space-y-6">
                    {/* Nome */}
                    <div>
                      <label htmlFor="nome" className="block text-sm font-medium text-gray-700 mb-1">
                        Nome Completo {(isCreating || isEditing || editMode) && <span className="text-red-500">*</span>}
                      </label>
                      <div className="relative">
                        <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                          <User size={18} className="text-gray-400" />
                        </div>
                        <input
                          type="text"
                          id="nome"
                          name="nome"
                          value={editedProfile.nome}
                          onChange={handleProfileChange}
                          disabled={!(isCreating || isEditing || editMode)}
                          className={`w-full pl-10 pr-3 py-2 bg-white border text-gray-700 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors ${
                            !(isCreating || isEditing || editMode) ? "bg-gray-50" : ""
                          }`}
                        />
                      </div>
                    </div>

                    {/* Email */}
                    <div>
                      <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
                        Email {(isCreating || isEditing || editMode) && <span className="text-red-500">*</span>}
                      </label>
                      <div className="relative">
                        <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                          <Mail size={18} className="text-gray-400" />
                        </div>
                        <input
                          type="email"
                          id="email"
                          name="email"
                          value={editedProfile.email}
                          onChange={handleProfileChange}
                          disabled={!(isCreating || isEditing || editMode)}
                          className={`w-full pl-10 text-gray-700 pr-3 py-2 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors ${
                            !(isCreating || isEditing || editMode) ? "bg-gray-50" : ""
                          }`}
                        />
                      </div>
                    </div>

                    {/* Tipo de Usuário */}
                    {(isCreating) ? (
                      <div>
                        <label htmlFor="tipoUsuarioId" className="block text-sm font-medium text-gray-700 mb-1">
                          Tipo de Usuário <span className="text-red-500">*</span>
                        </label>
                        <div className="relative">
                          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <UserCog size={18} className="text-gray-400" />
                          </div>
                          <select
                            id="tipoUsuarioId"
                            name="tipoUsuarioId"
                            value={editedProfile.tipoUsuarioId}
                            onChange={handleProfileChange}
                            className="w-full pl-10 pr-3 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors appearance-none"
                          >
                            <option value="">Selecione um tipo</option>
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
                    ) : (
                      <div>
                        <label htmlFor="tipoUsuario" className="block text-sm font-medium text-gray-700 mb-1">
                          Tipo de Usuário
                        </label>
                        <div className="relative">
                          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <UserCog size={18} className="text-gray-400" />
                          </div>
                          <input
                            type="text"
                            id="tipoUsuario"
                            value={tipoUsuarioLabel}
                            disabled
                            className="w-full pl-10 text-gray-700 pr-3 py-2 bg-gray-50 border border-gray-300 rounded-lg"
                          />
                        </div>
                      </div>
                    )}

                    {/* Senha - apenas para criação */}
                    {isCreating && (
                      <>
                        <div>
                          <label htmlFor="senha" className="block text-sm font-medium text-gray-700 mb-1">
                            Senha <span className="text-red-500">*</span>
                          </label>
                          <div className="relative">
                            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                              <Lock size={18} className="text-gray-400" />
                            </div>
                            <input
                              type={showPassword ? "text" : "password"}
                              id="senha"
                              name="senha"
                              value={editedProfile.senha}
                              onChange={handleProfileChange}
                              className="w-full pl-10 text-gray-700 pr-10 py-2 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors"
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
                          <p className="mt-1 text-sm text-gray-500">A senha deve ter pelo menos 6 caracteres</p>
                        </div>

                        <div>
                          <label htmlFor="confirmarSenha" className="block text-sm font-medium text-gray-700 mb-1">
                            Confirmar Senha <span className="text-red-500">*</span>
                          </label>
                          <div className="relative">
                            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                              <Lock size={18} className="text-gray-400" />
                            </div>
                            <input
                              type={showConfirmNewPassword ? "text" : "password"}
                              id="confirmarSenha"
                              name="confirmarSenha"
                              value={editedProfile.confirmarSenha}
                              onChange={handleProfileChange}
                              className="w-full pl-10 pr-10 text-gray-700 py-2 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition-colors"
                            />
                            <button
                              type="button"
                              className="absolute inset-y-0 right-0 pr-3 flex items-center"
                              onClick={() => setShowConfirmNewPassword(!showConfirmNewPassword)}
                            >
                              {showConfirmNewPassword ? (
                                <EyeOff size={18} className="text-gray-400 hover:text-gray-600" />
                              ) : (
                                <Eye size={18} className="text-gray-400 hover:text-gray-600" />
                              )}
                            </button>
                          </div>
                        </div>
                      </>
                    )}

                    {/* Datas - apenas para visualização e edição de perfil existente */}
                    {!isCreating && profile && (
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">Criado em</label>
                          <div className="relative">
                            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                              <Calendar size={18} className="text-gray-400" />
                            </div>
                            <input
                              type="text"
                              value={profile?.created_at ? formatDate(profile.created_at) : "N/A"}
                              disabled
                              className="w-full pl-10 text-gray-700 pr-3 py-2 bg-gray-50 border border-gray-300 rounded-lg"
                            />
                          </div>
                        </div>
                        <div>
                          <label className="block text-sm font-medium text-gray-700 mb-1">Atualizado em</label>
                          <div className="relative">
                            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                              <Clock size={18} className="text-gray-400" />
                            </div>
                            <input
                              type="text"
                              value={profile?.updated_at ? formatDate(profile.updated_at) : "N/A"}
                              disabled
                              className="w-full pl-10 text-gray-700 pr-3 py-2 bg-gray-50 border border-gray-300 rounded-lg"
                            />
                          </div>
                        </div>
                      </div>
                    )}

                    {/* Botões */}
                    {(isCreating || isEditing || editMode) && (
                      <div className="flex justify-end gap-3 pt-4">
                        <button
                          type="button"
                          onClick={handleCancel}
                          className="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors flex items-center gap-2"
                        >
                          <X size={18} />
                          Cancelar
                        </button>
                        <button
                          type="submit"
                          disabled={savingProfile}
                          className="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition-colors flex items-center gap-2"
                        >
                          {savingProfile ? (
                            <>
                              <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
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
                              Salvando...
                            </>
                          ) : (
                            <>
                              <Save size={18} />
                              Salvar
                            </>
                          )}
                        </button>
                      </div>
                    )}
                  </div>
                </form>
              </div>
            </div>
          </div>

          {/* Coluna da direita - Fazendas */}
          <div className="space-y-6">
            {/* Fazendas Associadas */}
            <div className="bg-white rounded-xl shadow-sm overflow-hidden">
              <div className="bg-gradient-to-r from-green-500 to-green-600 px-6 py-4 flex justify-between items-center">
                <h2 className="text-xl font-semibold text-white">Fazendas Associadas</h2>
                <button
                  onClick={() => {
                    if (!profile?.id) {
                      setNotification({
                        type: "error",
                        message: "Você precisa salvar o usuário antes de adicionar fazendas.",
                      })
                    } else {
                      fetchAvailableFarms()
                      setShowAddFarmModal(true)
                    }
                  }}
                  className="bg-white text-green-600 p-1.5 rounded-full hover:bg-green-50 transition-colors"
                  title="Adicionar Fazenda"
                >
                  <Plus size={18} />
                </button>
              </div>

              <div className="p-6">
                {profile?.usuarioFazendas && profile.usuarioFazendas.length > 0 ? (
                  <ul className="space-y-3">
                    {profile.usuarioFazendas.map((uf) => (
                      <li
                        key={uf.id}
                        className="flex items-start justify-between gap-3 p-3 bg-gray-50 rounded-lg border border-gray-200"
                      >
                        <div className="flex items-start gap-3">
                          <Building2 className="text-green-500 flex-shrink-0 mt-0.5" size={20} />
                          <div>
                            <h3 className="font-medium text-gray-800">{uf.fazenda.nome}</h3>
                            {uf.fazenda.cidade && (
                              <p className="text-sm text-gray-600">
                                {uf.fazenda.cidade.nome} - {uf.fazenda.cidade.uf?.sigla}
                              </p>
                            )}
                          </div>
                        </div>
                        <button
                          onClick={() => handleRemoveFarm(uf.fazenda.id)}
                          disabled={removingFarmId === uf.fazenda.id}
                          className={`text-red-500 hover:text-red-700 p-1 rounded-full hover:bg-red-50 ${
                            removingFarmId === uf.fazenda.id ? "opacity-50 cursor-not-allowed" : ""
                          }`}
                          title="Desvincular Fazenda"
                        >
                          {removingFarmId === uf.fazenda.id ? (
                            <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
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
                          ) : (
                            <Trash2 size={18} />
                          )}
                        </button>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <div className="text-center py-4">
                    <Building2 size={32} className="mx-auto text-gray-400 mb-2" />
                    <p className="text-gray-500">Nenhuma fazenda associada</p>
                    <button
                      onClick={() => {
                        if (!profile?.id) {
                          setNotification({
                            type: "error",
                            message: "Você precisa salvar o usuário antes de adicionar fazendas.",
                          })
                        } else {
                          fetchAvailableFarms()
                          setShowAddFarmModal(true)
                        }
                      }}
                      className="mt-3 text-sm text-green-600 hover:text-green-700 font-medium flex items-center justify-center gap-1 mx-auto"
                    >
                      <Plus size={16} /> Adicionar Fazenda
                    </button>
                  </div>
                )}
              </div>
            </div>

            {/* Add Farm Modal */}
            {showAddFarmModal && (
              <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
                <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                  <div className="flex justify-between items-center mb-4">
                    <h3 className="text-lg font-medium text-gray-900">Adicionar Fazenda</h3>
                    <button
                      onClick={() => setShowAddFarmModal(false)}
                      className="text-gray-400 hover:text-gray-500 rounded-full p-1 hover:bg-gray-100"
                    >
                      <X size={20} />
                    </button>
                  </div>

                  {/* Search */}
                  <div className="mb-4 relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <Search size={18} className="text-gray-400" />
                    </div>
                    <input
                      type="text"
                      placeholder="Buscar fazenda..."
                      value={searchFarmTerm}
                      onChange={(e) => setSearchFarmTerm(e.target.value)}
                      className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                    />
                  </div>

                  {/* Farm List */}
                  <div className="max-h-60 overflow-y-auto mb-4">
                    {availableFarms.length === 0 ? (
                      <div className="text-center py-8">
                        <Building2 size={32} className="mx-auto text-gray-400 mb-2" />
                        <p className="text-gray-500">Nenhuma fazenda disponível</p>
                      </div>
                    ) : (
                      <ul className="space-y-2">
                        {availableFarms
                          .filter(
                            (farm) =>
                              farm.nome.toLowerCase().includes(searchFarmTerm.toLowerCase()) ||
                              farm.cidade?.nome.toLowerCase().includes(searchFarmTerm.toLowerCase()) ||
                              farm.cidade?.uf?.sigla.toLowerCase().includes(searchFarmTerm.toLowerCase()),
                          )
                          .map((farm) => (
                            <li key={farm.id} className="border border-gray-200 rounded-lg p-3 hover:bg-gray-50">
                              <button
                                onClick={() => handleAddFarm(farm.id)}
                                disabled={addingFarm}
                                className="w-full text-left flex justify-between items-center"
                              >
                                <div>
                                  <h4 className="font-medium text-gray-800">{farm.nome}</h4>
                                  {farm.cidade && (
                                    <p className="text-sm text-gray-600">
                                      {farm.cidade.nome} - {farm.cidade.uf?.sigla}
                                    </p>
                                  )}
                                </div>
                                <Plus size={18} className="text-green-500" />
                              </button>
                            </li>
                          ))}
                      </ul>
                    )}
                  </div>

                  <div className="flex justify-end gap-3 pt-2 border-t border-gray-200">
                    <button
                      onClick={() => setShowAddFarmModal(false)}
                      className="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
                    >
                      Cancelar
                    </button>
                    <button
                      onClick={() => setShowAddFarmModal(false)}
                      disabled={addingFarm}
                      className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
                    >
                      {addingFarm ? (
                        <div className="flex items-center gap-2">
                          <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
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
                          Adicionando...
                        </div>
                      ) : (
                        "Concluir"
                      )}
                    </button>
                  </div>
                </div>
              </div>
            )}
            
          {(isEditing) && (
              <div className="space-y-6">
                {/* Alterar Senha */}
                <div className="bg-white rounded-xl shadow-sm overflow-hidden">
                  <div className="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-4">
                    <h2 className="text-xl font-semibold text-white">Alterar Senha</h2>
                  </div>

                  <div className="p-6">
                    <form onSubmit={handleChangePassword} className="space-y-4">
                      {/* Senha Atual */}
                      <div>
                        <label htmlFor="senhaAtual" className="block text-sm font-medium text-gray-700 mb-1">
                          Senha Atual
                        </label>
                        <div className="relative">
                          <div className="absolute inset-y-0 left-0 text-gray-700 pl-3 flex items-center pointer-events-none">
                            <Lock size={18} className="text-gray-400" />
                          </div>
                          <input
                            type={showCurrentPassword ? "text" : "password"}
                            id="senhaAtual"
                            name="senhaAtual"
                            value={passwordForm.senhaAtual}
                            onChange={handlePasswordChange}
                            className="w-full pl-10 pr-10 py-2 bg-white border text-gray-700 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                          />
                          <button
                            type="button"
                            className="absolute inset-y-0 right-0 pr-3 flex items-center"
                            onClick={() => setShowCurrentPassword(!showCurrentPassword)}
                          >
                            {showCurrentPassword ? (
                              <EyeOff size={18} className="text-gray-400 hover:text-gray-600" />
                            ) : (
                              <Eye size={18} className="text-gray-400 hover:text-gray-600" />
                            )}
                          </button>
                        </div>
                      </div>

                      {/* Nova Senha */}
                      <div>
                        <label htmlFor="novaSenha" className="block text-sm font-medium text-gray-700 mb-1">
                          Nova Senha
                        </label>
                        <div className="relative">
                          <div className="absolute inset-y-0 text-gray-700 left-0 pl-3 flex items-center pointer-events-none">
                            <Lock size={18} className="text-gray-400" />
                          </div>
                          <input
                            type={showNewPassword ? "text" : "password"}
                            id="novaSenha"
                            name="novaSenha"
                            value={passwordForm.novaSenha}
                            onChange={handlePasswordChange}
                            className="w-full pl-10 pr-10 py-2 bg-white border text-gray-700 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                          />
                          <button
                            type="button"
                            className="absolute inset-y-0 right-0 pr-3 flex items-center"
                            onClick={() => setShowNewPassword(!showNewPassword)}
                          >
                            {showNewPassword ? (
                              <EyeOff size={18} className="text-gray-400 hover:text-gray-600" />
                            ) : (
                              <Eye size={18} className="text-gray-400 hover:text-gray-600" />
                            )}
                          </button>
                        </div>
                      </div>

                      {/* Confirmar Senha */}
                      <div>
                        <label htmlFor="confirmarSenha" className="block text-sm font-medium text-gray-700 mb-1">
                          Confirmar Nova Senha
                        </label>
                        <div className="relative">
                          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <Lock size={18} className="text-gray-400" />
                          </div>
                          <input
                            type={showConfirmPassword ? "text" : "password"}
                            id="confirmarSenha"
                            name="confirmarSenha"
                            value={passwordForm.confirmarSenha}
                            onChange={handlePasswordChange}
                            className="w-full pl-10 text-gray-700 pr-10 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                          />
                          <button
                            type="button"
                            className="absolute inset-y-0 right-0 pr-3 flex items-center"
                            onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                          >
                            {showConfirmPassword ? (
                              <EyeOff size={18} className="text-gray-400 hover:text-gray-600" />
                            ) : (
                              <Eye size={18} className="text-gray-400 hover:text-gray-600" />
                            )}
                          </button>
                        </div>
                      </div>

                      <div className="pt-2">
                        <button
                          type="submit"
                          disabled={changingPassword}
                          className="w-full px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors flex items-center justify-center gap-2"
                        >
                          {changingPassword ? (
                            <>
                              <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
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
                              Alterando...
                            </>
                          ) : (
                            <>
                              <Lock size={18} />
                              Alterar Senha
                            </>
                          )}
                        </button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

const PageWithSuspense = () => (
  <Suspense fallback={<div>Loading...</div>}>
    <PerfilPage />
  </Suspense>
);

export default PageWithSuspense;
