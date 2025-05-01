"use client"

import { useState, useEffect } from "react"
import Cookie from "js-cookie"
import apiClient from "@/apiClient"
import { Chart, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement } from "chart.js"
import { Bar, Doughnut } from "react-chartjs-2"
import {
  Calendar,
  TrendingUp,
  Users,
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
  Plus,
  Award,
  Star,
} from "lucide-react"
import DatePicker from "react-datepicker"
import "react-datepicker/dist/react-datepicker.css"

// Registrar componentes do Chart.js
Chart.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement)

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

const formatMatrizesEstatisticas = (
  topNascimentos: any[],
  topMedia: { matrizId: number; numeroBrinco: string; mediaPorParto: number, totalPartos: number }[]
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
  const [dashboardData, setDashboardData] = useState<any>({})
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

  const fetchDashboardData = async (startDate: Date, endDate: Date) => {
    const formattedStartDate = startDate.toISOString().split("T")[0]
    const formattedEndDate = endDate.toISOString().split("T")[0]
    setRefreshing(true)

    try {
      const response = await apiClient.get(
        `/dashboard/${fazenda_id}?startDate=${formattedStartDate}&endDate=${formattedEndDate}`,
      )
      setDashboardData(response.data)

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
  }

  useEffect(() => {
    const userCookie = Cookie.get("user")
    if (userCookie) {
      const parsedUser = JSON.parse(userCookie)
      setUserName(parsedUser?.nome || "Usuário")
    }
    fetchDashboardData(startDate, endDate)
  }, [fazenda_id])

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

  // Função para formatar números
  const formatNumber = (num: number) => {
    return new Intl.NumberFormat("pt-BR").format(num || 0)
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
            <div className="mt-4 text-right">
              <button className="text-orange-500 hover:text-orange-600 text-sm font-medium flex items-center justify-end w-full">
                Ver todas as anotações
                <ArrowRight size={16} className="ml-1" />
              </button>
            </div>
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
              <div className="mt-4 text-right">
                <button className="text-orange-500 hover:text-orange-600 text-sm font-medium flex items-center justify-end w-full">
                  Ver todas as movimentações
                  <ArrowRight size={16} className="ml-1" />
                </button>
              </div>
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
                  {matrizesProximasParto.map((matriz) => (
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
                  ))}
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
                      {dashboardData?.mediaLeitoesPorParto >= 10 ? (
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
