"use client"

import { useState, useEffect, useCallback } from "react"
import Cookie from "js-cookie"
import apiClient from "@/apiClient"
import { Chart, CategoryScale, LinearScale, BarElement, Title, PointElement, LineElement, Tooltip, Legend, ArcElement } from "chart.js"
import { Bar, Doughnut, Line } from "react-chartjs-2"
import {
  Calendar,
  TrendingUp,
  Activity,
  BarChart2,
  RefreshCw,
  Baby,
  Frown,
  Home,
  ArrowRight,
  Clock,
  PiggyBank,
  ArrowRightLeft,
  FileText,
  Award,
  Star,
} from "lucide-react"
import DatePicker from "react-datepicker"
import "react-datepicker/dist/react-datepicker.css"

// Registrar componentes do Chart.js
Chart.register(CategoryScale, LinearScale, PointElement, LineElement, BarElement, Title, Tooltip, Legend, ArcElement)

// Adicionar interfaces para os novos dados
interface Movimentacao {
  id: number
  animal?: {
    numero_brinco: string
  }
  baiaOrigem?: {
    numero: string
  }
  baiaDestino?: {
    numero: string
  }
  tipo: number
  dataMovimentacao: string
  usuario?: {
    nome: string
  }
  observacoes?: string
}

interface MatrizProximaParto {
  id: number
  brinco: string
  dataPrevisaoParto: string
  diasRestantes: number
  baia: string
  paridade: number
}

interface Anotacao {
  id: number;
  descricao: string;
  data: string;
  createdBy: {
    nome: string;
  };
  baia?: {
    numero: string;
  };
  animal?: {
    numero_brinco: string;
  };
}

export interface MatrizEstatistica {
  matrizId: number;
  numeroBrinco: string;
  totalNascimentos?: number;
  totalPartos?: number;
  mediaPorParto?: number;
}

type Nascimento = {
  matrizId: number | string;
  numeroBrinco: string;
  totalNascimentos: number | string;
  totalPartos: number | string;
};

type Media = {
  matrizId: number;
  numeroBrinco: string;
  mediaPorParto: number;
  totalPartos: number;
};

interface VendasPorMes {
  jan: number;
  fev: number;
  mar: number;
  abr: number;
  mai: number;
  jun: number;
  jul: number;
  ago: number;
  set: number;
  out: number;
  nov: number;
  dez: number;
}

interface Sale {
  venda_id: string;
  venda_quantidade_vendida: number;
  venda_peso_venda: number;
  venda_data_venda: string;
  venda_valor_venda: number;
}

interface DashboardData {
  totalInseminacoes: number;
  nascimentosVivos: number;
  nascimentosMortos: number;
  matrizesGestando: number;
  vendasPorMes: VendasPorMes;
  totalSales: number;
  totalQuantity: number;
  totalWeight: number;
  averagePrice: number;
  mediaLeitoesPorParto: number | string;
  recentSales: Sale[];
}

const formatMatrizesEstatisticas = (
  topNascimentos: Nascimento[],
  topMedia: Media[]
): MatrizEstatistica[] => {
  const mapa = new Map<number, MatrizEstatistica>();

  topNascimentos.forEach((n) => {
    const id = Number(n.matrizId);
    mapa.set(id, {
      matrizId: id,
      numeroBrinco: n.numeroBrinco,
      totalNascimentos: Number(n.totalNascimentos),
      totalPartos: Number(n.totalPartos),
    });
  });

  topMedia.forEach((m) => {
    const id = Number(m.matrizId);
    const existente = mapa.get(id) || {
      matrizId: id,
      numeroBrinco: m.numeroBrinco,
      totalPartos: Number(m.totalPartos),
    };
    existente.mediaPorParto = Number(m.mediaPorParto);
    mapa.set(id, existente);
  });

  return Array.from(mapa.values());
};

const DashboardPage = () => {
  const fazenda_id = Cookie.get("selectedFarmId")
  const [userName, setUserName] = useState("")
  const [startDate, setStartDate] = useState(new Date(new Date().setDate(new Date().getDate() - 30))) // Último mês
  const [endDate, setEndDate] = useState(new Date())
  const [dashboardData, setDashboardData] = useState<DashboardData>({
    totalInseminacoes: 0,
    nascimentosVivos: 0,
    nascimentosMortos: 0,
    matrizesGestando: 0,
    vendasPorMes: {
      jan: 0, fev: 0, mar: 0, abr: 0, mai: 0, jun: 0, jul: 0,
      ago: 0, set: 0, out: 0, nov: 0, dez: 0,
    },
    totalSales: 0,
    totalQuantity: 0,
    totalWeight: 0,
    averagePrice: 0,
    mediaLeitoesPorParto: "N/A",
    recentSales: [],
  });  
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)

  // Novos estados para os dados adicionais
  const [totalAnimais, setTotalAnimais] = useState(0)
  const [totalMovimentacoes, setTotalMovimentacoes] = useState(0)
  const [baiasInfo, setBaiasInfo] = useState({ ocupadas: 0, total: 0, taxa: "0%" })
  const [ultimasMovimentacoes, setUltimasMovimentacoes] = useState<Movimentacao[]>([])
  const [leitoesCreche, setLeitoesCreche] = useState({ total: 0, idadeMedia: 0 })
  const [matrizesProximasParto, setMatrizesProximasParto] = useState<MatrizProximaParto[]>([])
  const [anotacoes, setAnotacoes] = useState<Anotacao[]>([])
  const [matrizesEstatisticas, setMatrizesEstatisticas] = useState<MatrizEstatistica[]>([])

  const fetchDashboardData = useCallback(async (startDate: Date, endDate: Date) => {
    const formattedStartDate = startDate.toISOString().split("T")[0]
    const formattedEndDate = endDate.toISOString().split("T")[0]
    setRefreshing(true)

    try {
      const response = await apiClient.get(
        `/dashboard/${fazenda_id}?startDate=${formattedStartDate}&endDate=${formattedEndDate}`,
      )
      const data = response.data
      setDashboardData(data)
      setTotalAnimais(data.totalAnimais)
      setTotalMovimentacoes(data.totalMovimentacoes)
      setBaiasInfo({
        ocupadas: data.ocupacaoBaias.ocupadas,
        total: data.ocupacaoBaias.ocupadas + data.ocupacaoBaias.livres,
        taxa: `${Math.round(
          (data.ocupacaoBaias.ocupadas / (data.ocupacaoBaias.ocupadas + data.ocupacaoBaias.livres)) * 100
        )}%`,
      })
      setUltimasMovimentacoes(data.movimentacoes || [])
      setLeitoesCreche({
        total: data.leitoesEmCrecheObj?.total || 0,
        idadeMedia: data.leitoesEmCrecheObj?.idadeMedia || 0,
      })
      setMatrizesProximasParto(data.matrizesProxDoPartoComDadosCalculados || [])
      setAnotacoes(data.anotacoesDoDia?.lista || [])
      setMatrizesEstatisticas(
        formatMatrizesEstatisticas(
          data.topMatrizesPorTotalNascimentos || [],
          data.topMatrizesPorMedia || []
        )
      )      
    } catch (error) {
      console.error("Erro ao buscar dados do dashboard", error)
    } finally {
      setLoading(false)
      setRefreshing(false)
    }
  }, [fazenda_id])

  useEffect(() => {
    const userCookie = Cookie.get("user")
    if (userCookie) {
      const parsedUser = JSON.parse(userCookie)
      setUserName(parsedUser?.nome || "Usuário")
    }
    fetchDashboardData(startDate, endDate)
  }, [fazenda_id, startDate, endDate, fetchDashboardData])

  // Dados para o gráfico de barras
  const barChartData = {
    labels: ["Inseminações", "Nascimentos Vivos", "Nascimentos Mortos", "Matrizes em Gestação"],
    datasets: [
      {
        label: "Indicadores do Período",
        data: [
          dashboardData?.totalInseminacoes || 0,
          dashboardData?.nascimentosVivos || 0,
          dashboardData?.nascimentosMortos || 0,
          dashboardData?.matrizesGestando || 0,
        ],
        backgroundColor: [
          "rgba(54, 162, 235, 0.7)",
          "rgba(75, 192, 192, 0.7)",
          "rgba(255, 99, 132, 0.7)",
          "rgba(255, 206, 86, 0.7)",
        ],
        borderColor: [
          "rgba(54, 162, 235, 1)",
          "rgba(75, 192, 192, 1)",
          "rgba(255, 99, 132, 1)",
          "rgba(255, 206, 86, 1)",
        ],
        borderWidth: 1,
      },
    ],
  }

  const salesLineData = {
    labels: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
    datasets: [
      {
        label: "Valor de Vendas (R$)",
        data: [
          dashboardData?.vendasPorMes?.jan || 0,
          dashboardData?.vendasPorMes?.fev || 0,
          dashboardData?.vendasPorMes?.mar || 0,
          dashboardData?.vendasPorMes?.abr || 0,
          dashboardData?.vendasPorMes?.mai || 0,
          dashboardData?.vendasPorMes?.jun || 0,
          dashboardData?.vendasPorMes?.jul || 0,
          dashboardData?.vendasPorMes?.ago || 0,
          dashboardData?.vendasPorMes?.set || 0,
          dashboardData?.vendasPorMes?.out || 0,
          dashboardData?.vendasPorMes?.nov || 0,
          dashboardData?.vendasPorMes?.dez || 0,
        ],
        borderColor: "rgba(75, 192, 192, 1)",
        backgroundColor: "rgba(75, 192, 192, 0.2)",
        borderWidth: 2,
        fill: true,
        tension: 0.4,
      },
    ],
  };  

  // Dados para o gráfico de rosca
  const doughnutData = {
    labels: ["Nascimentos Vivos", "Nascimentos Mortos"],
    datasets: [
      {
        data: [dashboardData?.nascimentosVivos || 0, dashboardData?.nascimentosMortos || 0],
        backgroundColor: ["rgba(75, 192, 192, 0.7)", "rgba(255, 99, 132, 0.7)"],
        borderColor: ["rgba(75, 192, 192, 1)", "rgba(255, 99, 132, 1)"],
        borderWidth: 1,
      },
    ],
  }

  // Opções para os gráficos
  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: "bottom" as const,
      },
      title: {
        display: true,
        text: "Indicadores do Período",
      },
    },
  }

  const lineChartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: "bottom" as const,
      },
      title: {
        display: true,
        text: "Vendas Mensais",
      },
    },
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  // Função para formatar números
  const formatNumber = (num: number) => {
    return new Intl.NumberFormat("pt-BR").format(num || 0)
  }

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }).format(value || 0)
  }

  // Função para formatar weight values
  const formatWeight = (weight: number) => {
    return `${new Intl.NumberFormat("pt-BR").format(weight || 0)} kg`
  }

  // Calcular taxa de mortalidade
  const calcularTaxaMortalidade = () => {
    const vivos = dashboardData?.nascimentosVivos || 0
    const mortos = dashboardData?.nascimentosMortos || 0
    const total = vivos + mortos

    if (total === 0) return "0%"
    return `${((mortos / total) * 100).toFixed(1)}%`
  }

  // Formatar data e hora
  const formatDateTime = (dateString: string) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date)
  }

  // Formatar apenas data
  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    }).format(date)
  }

  return (
    <div className="flex flex-col space-y-6">
      {/* Cabeçalho do Dashboard */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 bg-white p-6 rounded-xl shadow-md">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold text-gray-800">
            Dashboard
            <span className="text-orange-500 ml-2">{userName}</span>
          </h1>
          <p className="text-gray-500 mt-1">Acompanhe os principais indicadores da sua fazenda</p>
        </div>

        {/* Seletor de datas e botão de atualização */}
        <div className="flex flex-col md:flex-row items-start md:items-center gap-4 w-full md:w-auto">
          <div className="flex items-center gap-2 bg-gray-50 p-2 rounded-lg border border-gray-200 w-full md:w-auto">
            <Calendar className="text-gray-500" size={18} />
            <DatePicker
              selected={startDate}
              onChange={(date) => date && setStartDate(date)}
              selectsStart
              startDate={startDate}
              endDate={endDate}
              className="bg-transparent border-none focus:outline-none text-sm text-gray-700 w-24"
              dateFormat="dd/MM/yyyy"
            />
            <DatePicker
              selected={endDate}
              onChange={(date) => date && setEndDate(date)}
              selectsEnd
              startDate={startDate}
              endDate={endDate}
              minDate={startDate}
              className="bg-transparent border-none focus:outline-none text-sm text-gray-700 w-24"
              dateFormat="dd/MM/yyyy"
            />
          </div>
          <button
            onClick={() => fetchDashboardData(startDate, endDate)}
            disabled={refreshing}
            className="flex items-center justify-center gap-2 bg-orange-500 hover:bg-orange-600 text-white py-2 px-4 rounded-lg transition-colors w-full md:w-auto"
          >
            <RefreshCw size={18} className={`${refreshing ? "animate-spin" : ""}`} />
            {refreshing ? "Atualizando..." : "Atualizar"}
          </button>
        </div>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 animate-pulse">
          {[...Array(8)].map((_, i) => (
            <div key={i} className="bg-white p-6 rounded-xl shadow-md h-40">
              <div className="h-4 bg-gray-200 rounded w-1/2 mb-4"></div>
              <div className="h-8 bg-gray-200 rounded w-1/4 mb-2"></div>
              <div className="h-4 bg-gray-200 rounded w-3/4"></div>
            </div>
          ))}
        </div>
      ) : (
        <>
          {/* Cards de Indicadores - Primeira linha */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {/* Inseminações */}
            <div className="bg-gradient-to-br from-blue-50 to-white p-6 rounded-xl shadow-md border-l-4 border-blue-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Inseminações</h3>
                  <p className="text-3xl font-bold text-blue-500">
                    {formatNumber(dashboardData?.totalInseminacoes || 0)}
                  </p>
                  <p className="text-sm text-gray-500 mt-2">No período selecionado</p>
                </div>
                <div className="bg-blue-100 p-3 rounded-full">
                  <Activity className="text-blue-500" size={24} />
                </div>
              </div>
            </div>

            {/* Nascimentos Vivos */}
            <div className="bg-gradient-to-br from-green-50 to-white p-6 rounded-xl shadow-md border-l-4 border-green-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Nascimentos Vivos</h3>
                  <p className="text-3xl font-bold text-green-500">
                    {formatNumber(dashboardData?.nascimentosVivos || 0)}
                  </p>
                  <p className="text-sm text-gray-500 mt-2">No período selecionado</p>
                </div>
                <div className="bg-green-100 p-3 rounded-full">
                  <Baby className="text-green-500" size={24} />
                </div>
              </div>
            </div>

            {/* Nascimentos Mortos */}
            <div className="bg-gradient-to-br from-red-50 to-white p-6 rounded-xl shadow-md border-l-4 border-red-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Nascimentos Mortos</h3>
                  <p className="text-3xl font-bold text-red-500">
                    {formatNumber(dashboardData?.nascimentosMortos || 0)}
                  </p>
                  <p className="text-sm text-gray-500 mt-2">Taxa de mortalidade: {calcularTaxaMortalidade()}</p>
                </div>
                <div className="bg-red-100 p-3 rounded-full">
                  <Frown className="text-red-500" size={24} />
                </div>
              </div>
            </div>

            {/* Quantidade de matrizes gestando */}
            <div className="bg-gradient-to-br from-yellow-50 to-white p-6 rounded-xl shadow-md border-l-4 border-yellow-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Matrizes em Gestação</h3>
                  <p className="text-3xl font-bold text-yellow-500">
                    {formatNumber(dashboardData?.matrizesGestando || 0)}
                  </p>
                  <p className="text-sm text-gray-500 mt-2">Atualmente</p>
                </div>
                <div className="bg-yellow-100 p-3 rounded-full">
                  <Baby className="text-yellow-500" size={24} />
                </div>
              </div>
            </div>
          </div>

          {/* Cards de Indicadores - Segunda linha (Novos cards) */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {/* Total de Animais */}
            <div className="bg-gradient-to-br from-purple-50 to-white p-6 rounded-xl shadow-md border-l-4 border-purple-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Total de Animais</h3>
                  <p className="text-3xl font-bold text-purple-500">{formatNumber(totalAnimais)}</p>
                  <p className="text-sm text-gray-500 mt-2">Em toda a fazenda</p>
                </div>
                <div className="bg-purple-100 p-3 rounded-full">
                  <PiggyBank className="text-purple-500" size={24} />
                </div>
              </div>
            </div>

            {/* Total de Movimentações */}
            <div className="bg-gradient-to-br from-indigo-50 to-white p-6 rounded-xl shadow-md border-l-4 border-indigo-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Movimentações</h3>
                  <p className="text-3xl font-bold text-indigo-500">{formatNumber(totalMovimentacoes)}</p>
                  <p className="text-sm text-gray-500 mt-2">No período selecionado</p>
                </div>
                <div className="bg-indigo-100 p-3 rounded-full">
                  <ArrowRightLeft className="text-indigo-500" size={24} />
                </div>
              </div>
            </div>

            {/* Baias Ocupadas */}
            <div className="bg-gradient-to-br from-teal-50 to-white p-6 rounded-xl shadow-md border-l-4 border-teal-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Baias Ocupadas</h3>
                  <p className="text-3xl font-bold text-teal-500">
                    {baiasInfo.ocupadas} <span className="text-lg font-normal text-gray-500">/ {baiasInfo.total}</span>
                  </p>
                  <p className="text-sm text-gray-500 mt-2">Taxa de ocupação: {baiasInfo.taxa}</p>
                </div>
                <div className="bg-teal-100 p-3 rounded-full">
                  <Home className="text-teal-500" size={24} />
                </div>
              </div>
            </div>
          </div>

          {/* Sales Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mt-6">
            {/* Total Sales Value */}
            <div className="bg-gradient-to-br from-green-50 to-white p-6 rounded-xl shadow-md border-l-4 border-green-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Valor Total de Vendas</h3>
                  <p className="text-3xl font-bold text-green-500">{formatCurrency(dashboardData.totalSales)}</p>
                  <p className="text-sm text-gray-500 mt-2">No período selecionado</p>
                </div>
                <div className="bg-green-100 p-3 rounded-full">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-green-500"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>
              </div>
            </div>

            {/* Quantity Sold */}
            <div className="bg-gradient-to-br from-blue-50 to-white p-6 rounded-xl shadow-md border-l-4 border-blue-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Quantidade Vendida</h3>
                  <p className="text-3xl font-bold text-blue-500">{formatNumber(dashboardData.totalQuantity)}</p>
                  <p className="text-sm text-gray-500 mt-2">Animais vendidos</p>
                </div>
                <div className="bg-blue-100 p-3 rounded-full">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-blue-500"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
                    />
                  </svg>
                </div>
              </div>
            </div>

            {/* Total Weight */}
            <div className="bg-gradient-to-br from-purple-50 to-white p-6 rounded-xl shadow-md border-l-4 border-purple-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Peso Total</h3>
                  <p className="text-3xl font-bold text-purple-500">{formatWeight(dashboardData.totalWeight)}</p>
                  <p className="text-sm text-gray-500 mt-2">Peso total vendido</p>
                </div>
                <div className="bg-purple-100 p-3 rounded-full">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-purple-500"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3"
                    />
                  </svg>
                </div>
              </div>
            </div>

            {/* Average Price */}
            <div className="bg-gradient-to-br from-amber-50 to-white p-6 rounded-xl shadow-md border-l-4 border-amber-500 hover:shadow-lg transition-shadow">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-1">Preço Médio</h3>
                  <p className="text-3xl font-bold text-amber-500">{formatCurrency(dashboardData.averagePrice)}</p>
                  <p className="text-sm text-gray-500 mt-2">Por kg</p>
                </div>
                <div className="bg-amber-100 p-3 rounded-full">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    className="h-6 w-6 text-amber-500"
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
              </div>
            </div>
          </div>

          {/* Sales Charts and Recent Sales */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-6">
            {/* Sales Line Chart */}
            <div className="bg-white p-6 rounded-xl shadow-md lg:col-span-2">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-5 w-5 mr-2 text-green-500"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z"
                  />
                </svg>
                Vendas Mensais
              </h3>
              <div className="h-80">
                <Line data={salesLineData} options={lineChartOptions} />
              </div>
            </div>

            {/* Recent Sales */}
            <div className="bg-white p-6 rounded-xl shadow-md">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-5 w-5 mr-2 text-blue-500"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
                  />
                </svg>
                Vendas Recentes
              </h3>
              <div className="overflow-y-auto max-h-72">
                {dashboardData.recentSales.length > 0 ? (
                  <ul className="space-y-3">
                    {dashboardData.recentSales.map((sale: Sale) => (
                      <li key={sale.venda_id} className="border-b border-gray-100 pb-3 last:border-0">
                        <div className="flex justify-between items-start">
                          <div>
                            <p className="font-medium text-gray-800">{formatNumber(sale.venda_quantidade_vendida)} animais</p>
                            <p className="text-sm text-gray-500">
                              {formatWeight(sale.venda_peso_venda)} • {new Date(sale.venda_data_venda).toLocaleDateString("pt-BR")}
                            </p>
                          </div>
                          <span className="font-semibold text-green-600">{formatCurrency(sale.venda_valor_venda)}</span>
                        </div>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <div className="text-center py-8 text-gray-500">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      className="h-12 w-12 mx-auto text-gray-300 mb-3"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"
                      />
                    </svg>
                    <p>Nenhuma venda recente encontrada</p>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Gráficos */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Gráfico de Barras */}
            <div className="bg-white p-6 rounded-xl shadow-md lg:col-span-2">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <BarChart2 className="mr-2 text-orange-500" size={20} />
                Indicadores do Período
              </h3>
              <div className="h-110">
                <Bar data={barChartData} options={chartOptions} />
              </div>
            </div>

            {/* Gráfico de Rosca */}
            <div className="bg-white p-6 rounded-xl shadow-md">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <TrendingUp className="mr-2 text-orange-500" size={20} />
                Taxa de Nascimentos
              </h3>
              <div className="h-80 flex items-center justify-center">
                <Doughnut
                  data={doughnutData}
                  options={{
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                      legend: {
                        position: "bottom",
                      },
                    },
                  }}
                />
              </div>
            </div>
          </div>

          {/* Anotações */}
          <div className="bg-white p-6 rounded-xl shadow-md">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-xl font-semibold text-gray-700 flex items-center">
                <FileText className="mr-2 text-orange-500" size={20} />
                Anotações Recentes
              </h3>
            </div>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead>
                  <tr>
                    <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Descrição
                    </th>
                    <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Vinculado a
                    </th>
                    <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Usuário
                    </th>
                    <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Data
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                {anotacoes.map((anotacao) => (
                  <tr key={anotacao.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3">
                      <div className="text-sm text-gray-900 line-clamp-2">{anotacao.descricao}</div>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap">
                      <div className="flex flex-col text-sm">
                        {anotacao.animal && (
                          <span className="inline-flex items-center text-xs font-medium text-blue-700 bg-blue-50 px-2 py-0.5 rounded-full mb-1">
                            <PiggyBank size={12} className="mr-1" />
                            Animal: {anotacao.animal.numero_brinco}
                          </span>
                        )}
                        {anotacao.baia && (
                          <span className="inline-flex items-center text-xs font-medium text-green-700 bg-green-50 px-2 py-0.5 rounded-full">
                            <Home size={12} className="mr-1" />
                            Baia: {anotacao.baia.numero}
                          </span>
                        )}
                      </div>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-sm text-gray-500">
                      {anotacao.createdBy?.nome || "-"}
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-sm text-gray-500">
                      <div className="flex items-center">
                        <Calendar size={14} className="mr-1 text-gray-400" />
                        {formatDate(anotacao.data)}
                      </div>
                    </td>
                  </tr>
                ))}
                </tbody>
              </table>
            </div>
            {/* <div className="mt-4 text-right">
              <button className="text-orange-500 hover:text-orange-600 text-sm font-medium flex items-center justify-end w-full">
                Ver todas as anotações
                <ArrowRight size={16} className="ml-1" />
              </button>
            </div> */}
          </div>

          {/* Matrizes com Melhores Estatísticas */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Matrizes com Maior Quantidade de Nascimentos */}
            <div className="bg-white p-6 rounded-xl shadow-md">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <Award className="mr-2 text-orange-500" size={20} />
                Matrizes com Maior Quantidade de Nascimentos
              </h3>
              <div className="space-y-4">
                {matrizesEstatisticas
                  .filter((m) => m.totalNascimentos != null)
                  .sort((a, b) => (b.totalNascimentos ?? 0) - (a.totalNascimentos ?? 0))
                  .slice(0, 3)
                  .map((matriz, index) => (
                    <div
                      key={matriz.matrizId}
                      className="flex items-center justify-between p-3 bg-amber-50 rounded-lg border border-amber-100"
                    >
                      <div className="flex items-center">
                        <div className="flex items-center justify-center w-8 h-8 rounded-full bg-amber-200 text-amber-700 font-bold mr-3">
                          {index + 1}
                        </div>
                        <div>
                          <div className="font-medium text-gray-800">{matriz.numeroBrinco}</div>
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-2xl font-bold text-amber-600">{matriz.totalNascimentos}</div>
                        <div className="text-xs text-gray-500">em {matriz.totalPartos ?? "?"} partos</div>
                      </div>
                    </div>
                  ))}
              </div>
            </div>

            {/* Matrizes com Maior Média por Parto */}
            <div className="bg-white p-6 rounded-xl shadow-md">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <Star className="mr-2 text-orange-500" size={20} />
                Matrizes com Maior Média por Parto
              </h3>
              <div className="space-y-4">
                {matrizesEstatisticas
                  .filter((m) => m.mediaPorParto != null)
                  .sort((a, b) => (b.mediaPorParto ?? 0) - (a.mediaPorParto ?? 0))
                  .slice(0, 3)
                  .map((matriz, index) => (
                    <div
                      key={matriz.matrizId}
                      className="flex items-center justify-between p-3 bg-blue-50 rounded-lg border border-blue-100"
                    >
                      <div className="flex items-center">
                        <div className="flex items-center justify-center w-8 h-8 rounded-full bg-blue-200 text-blue-700 font-bold mr-3">
                          {index + 1}
                        </div>
                        <div>
                          <div className="font-medium text-gray-800">{matriz.numeroBrinco}</div>
                          <div className="text-sm text-gray-600">Total de partos: {matriz.totalPartos ?? "?"}</div>
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-2xl font-bold text-blue-600">
                          {matriz.mediaPorParto?.toFixed(1)}
                        </div>
                        <div className="text-xs text-gray-500">leitões por parto</div>
                      </div>
                    </div>
                  ))}
              </div>
            </div>
          </div>


          {/* Novas seções */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Últimas Movimentações */}
            <div className="bg-white p-6 rounded-xl shadow-md">
              <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <ArrowRightLeft className="mr-2 text-orange-500" size={20} />
                Últimas Movimentações
              </h3>
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead>
                    <tr>
                      <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Animal
                      </th>
                      <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Movimentação
                      </th>
                      <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Responsável
                      </th>
                      <th className="px-4 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Data/Hora
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {ultimasMovimentacoes.map((mov) => (
                      <tr key={mov.id} className="hover:bg-gray-50">
                        <td className="px-4 py-3 whitespace-nowrap">
                          {mov.animal?.numero_brinco ? (
                            <span className="font-medium text-gray-900">{mov.animal?.numero_brinco}</span>
                          ) : (
                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                              Novo leitão
                            </span>
                          )}
                        </td>
                        <td className="px-4 py-3 whitespace-nowrap">
                          <div className="text-sm text-gray-900">
                            {mov.tipo === 1 ? (
                              <span>Nascimento → {mov.baiaDestino?.numero}</span>
                            ) : (
                              <div className="flex items-center">
                                <span>{mov.baiaOrigem?.numero ?? "Entrada"}</span>
                                <ArrowRight size={14} className="mx-1 text-gray-400" />
                                <span>{mov.baiaDestino?.numero}</span>
                              </div>
                            )}
                          </div>
                        </td>
                        <td className="px-4 py-3 whitespace-nowrap text-sm text-gray-500">{mov.usuario?.nome ?? "-"}</td>
                        <td className="px-4 py-3 whitespace-nowrap text-sm text-gray-500">
                          <div className="flex items-center">
                            <Clock size={14} className="mr-1 text-gray-400" />
                            {formatDateTime(mov.dataMovimentacao)}
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              {/* <div className="mt-4 text-right">
                <button className="text-orange-500 hover:text-orange-600 text-sm font-medium flex items-center justify-end w-full">
                  Ver todas as movimentações
                  <ArrowRight size={16} className="ml-1" />
                </button>
              </div> */}
            </div>

            {/* Leitões em Creche e Matrizes */}
            <div className="space-y-6">
              {/* Leitões em Creche */}
              <div className="bg-white p-6 rounded-xl shadow-md">
                <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                  <Baby className="mr-2 text-orange-500" size={20} />
                  Leitões em Creche
                </h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-blue-50 p-6 rounded-lg text-center">
                    <p className="text-sm text-gray-600 mb-1">Total</p>
                    <p className="text-2xl font-bold text-blue-600">{leitoesCreche.total}</p>
                  </div>
                  <div className="bg-purple-50 p-6 rounded-lg text-center">
                    <p className="text-sm text-gray-600 mb-1">Idade Média (Dias)</p>
                    <p className="text-2xl font-bold text-purple-600">{leitoesCreche.idadeMedia} dias</p>
                  </div>
                </div>
              </div>

              {/* Matrizes Próximas do Parto */}
              <div className="bg-white p-6 rounded-xl shadow-md">
                <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                  <Calendar className="mr-2 text-orange-500" size={20} />
                  Matrizes Próximas do Parto
                </h3>
                <div className="space-y-3">
                  {matrizesProximasParto.length > 0 ? (
                    matrizesProximasParto.map((matriz) => (
                      <div
                        key={matriz.id}
                        className="flex items-center justify-between p-3 bg-orange-50 rounded-lg border border-orange-100"
                      >
                        <div>
                          <div className="flex items-center">
                            <PiggyBank size={18} className="text-orange-500 mr-2" />
                            <span className="font-medium text-gray-800">{matriz.brinco}</span>
                            <span className="ml-2 px-2 py-0.5 bg-orange-100 text-orange-700 text-xs rounded-full">
                              {matriz.paridade}ª cria
                            </span>
                          </div>
                          <div className="text-sm text-gray-600 mt-1">
                            <span className="font-medium">Baia:</span> {matriz.baia}
                          </div>
                        </div>
                        <div className="text-right">
                          <div className="text-sm font-medium text-gray-900">{formatDate(matriz.dataPrevisaoParto)}</div>
                          <div className="text-xs text-orange-600 font-medium">Faltam {matriz.diasRestantes} dias</div>
                        </div>
                      </div>
                    ))
                  ) : (
                    <div className="text-center text-gray-500">Não há matrizes próximas do parto.</div>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Estatísticas Adicionais */}
          <div className="bg-white p-6 rounded-xl shadow-md">
            <h3 className="text-xl font-semibold text-gray-700 mb-4 flex items-center">
              <Activity className="mr-2 text-orange-500" size={20} />
              Estatísticas Detalhadas
            </h3>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead>
                  <tr>
                    <th className="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Indicador
                    </th>
                    <th className="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Valor
                    </th>
                    <th className="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Comparação
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Média de Leitões por Parto
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {dashboardData?.mediaLeitoesPorParto || "N/A"}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {typeof dashboardData?.mediaLeitoesPorParto === "number" && dashboardData.mediaLeitoesPorParto >= 10 ? (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                          Bom
                        </span>
                      ) : (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                          Abaixo do esperado
                        </span>
                      )}
                    </td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      Taxa de Mortalidade
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {calcularTaxaMortalidade()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {parseFloat(calcularTaxaMortalidade().replace('%', '')) < 5 ? (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                          Baixa
                        </span>
                      ) : (
                        <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                          Alta
                        </span>
                      )}
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </>
      )}
    </div>
  )
}

export default DashboardPage
