import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_baia_acoes_tab_card.dart';
import 'package:syspig/components/cards/custom_baia_informacoes_tab_card.dart';
import 'package:syspig/controller/ocupacao_baia_tela/ocupacao_baia_tela_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/themes/themes.dart';

class BaiaPage extends StatefulWidget {
  final int? baiaId;

  const BaiaPage({Key? key, this.baiaId}) : super(key: key);

  @override
  State<BaiaPage> createState() => BaiaPageState();
}

class BaiaPageState extends State<BaiaPage> {
  final OcupacaoBaiaTelaController _ocupacaoBaiaTelaController = OcupacaoBaiaTelaController();

  BaiaModel? _baia;
  OcupacaoModel? _ocupacao;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void didUpdateWidget(covariant BaiaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baiaId != widget.baiaId) {
      _carregarDados();
    }
  }

  Future<void> _carregarDados() async {
    setState(() => _isLoading = true);
    await _carregarBaia();
    await _carregarOcupacao();
    setState(() => _isLoading = false);
  }

  Future<void> _carregarBaia() async {   
    final baia = await _ocupacaoBaiaTelaController.fetchBaiaById(widget.baiaId!);
    setState(() => _baia = baia);
  }

  Future<void> _carregarOcupacao() async {   
    final ocupacao = await _ocupacaoBaiaTelaController.fetchOcupacaoByBaia(widget.baiaId!);

    if (ocupacao == null) {
      Navigator.pop(context);
    }

    setState(() => _ocupacao = ocupacao);
  }

  Future<void> recarregarDados() async {
    await _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: const Text('Carregando...'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            'Nº: ${_baia!.numero} - Código Ocupação: ${_ocupacao?.codigo ?? "Sem ocupação"}',
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: recarregarDados,
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Ações'),
              Tab(text: 'Informações'),
            ],
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: TabBarView(
          children: _ocupacao != null
              ? [
                  CustomBaiaAcoesTabCard(
                    baia: _baia,
                    ocupacao: _ocupacao,
                    recarregarDados: recarregarDados,
                  ),
                  CustomBaiaInformacoesTabCard(ocupacao: _ocupacao),
                ]
              : [
                  Center(child: Text("Nenhuma ocupação encontrada", style: TextStyle(fontSize: 18))),
                  Center(child: Text("Nenhuma informação disponível", style: TextStyle(fontSize: 18))),
                ],
        ),
      ),
    );
  }
}
