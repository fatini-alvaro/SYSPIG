import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syspig/components/cards/custom_pre_visualizacao_anotacao_card.dart';
import 'package:syspig/model/dashboard_model.dart';
import 'package:syspig/repositories/dashboard/dashboard_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color cardColor = Colors.orange.shade100;
  final Color iconColor = Colors.orange;

  DashboardModel? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      final repository = DashboardRepositoryImp();
      final data = await repository.getDados(fazendaId);
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } else {
      Logger().e('ID da fazenda não encontrado');
    }
  }

  Widget _buildIndicatorCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      child: Container(
        width: 160,
        height: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    double ocupadas = dashboardData?.baiasOcupadas?.toDouble() ?? 0;
    double livres = dashboardData?.baiasLivres?.toDouble() ?? 0;

    Map<String, double> dataMap = {
      "Ocupadas": ocupadas,
      "Livres": livres,
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Ocupação das Baias",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                colorList: [Colors.green, Colors.red],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 24,
                legendOptions: LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOcupacaoInfo("Ocupadas", ocupadas.toInt(), Colors.green),
                _buildOcupacaoInfo("Livres", livres.toInt(), Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnotacoes(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Informações do dia",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
            SizedBox(height: 4),
            Divider(thickness: 2, color: Colors.orange.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (dashboardData?.anotacoes != null && dashboardData!.anotacoes!.isNotEmpty)
                    ...?dashboardData?.anotacoes?.map((anotacao) => CustomPreVisualizacaoAnotacaoCard(anotacao: anotacao)).toList()
                  else
                    Text("Nenhuma anotação hoje"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOcupacaoInfo(String label, int quantidade, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: color,
        ),
        SizedBox(height: 4),
        Text(
          "$quantidade",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
    ? Center(child: CircularProgressIndicator())
    : dashboardData == null
        ? Center(child: Text("Erro ao carregar dados"))
        : SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Anotações do dia",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Divider(thickness: 2, color: Colors.orange.shade200),
              ],
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildIndicatorCard('Inseminações hoje', '${dashboardData!.inseminacoesHoje}', FontAwesomeIcons.syringe),
              _buildIndicatorCard('Nascimentos (Vivos)', '${dashboardData!.nascimentosVivos}', FontAwesomeIcons.baby),
              _buildIndicatorCard('Nascimentos (Mortos)', '${dashboardData!.nascimentosMortos}', FontAwesomeIcons.skull),
              _buildIndicatorCard('Animais em Baias', '${dashboardData!.animaisEmBaias}', FontAwesomeIcons.piggyBank),
              _buildIndicatorCard('Anotações do dia', '${dashboardData!.anotacoesDoDia}', FontAwesomeIcons.noteSticky),
              _buildIndicatorCard('Lotes ativos', '${dashboardData!.lotesAtivos}', FontAwesomeIcons.listCheck),
              _buildIndicatorCard('Matrizes gestando', '${dashboardData!.matrizesGestando}', FontAwesomeIcons.female),
              _buildIndicatorCard('Leitões em creche', '${dashboardData!.leitoesEmCreche}', FontAwesomeIcons.child),
              _buildIndicatorCard('Movimentações', '${dashboardData!.totalMovimentacoes}', FontAwesomeIcons.arrowRightArrowLeft),
            ],
          ),
          SizedBox(height: 4),
          Divider(thickness: 2, color: Colors.orange.shade200),
          _buildPieChart(context),
          _buildAnotacoes(context),
        ],
      ),
    );
  }
}
