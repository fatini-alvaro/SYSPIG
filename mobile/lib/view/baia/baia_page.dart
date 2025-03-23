import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_baia_acoes_tab_card.dart';
import 'package:syspig/components/cards/custom_baia_informacoes_tab_card.dart';
import 'package:syspig/controller/ocupacao_baia_tela/ocupacao_baia_tela_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/themes/themes.dart';

class BaiaPage extends StatefulWidget {
  final int? baiaId;

  BaiaPage({Key? key, this.baiaId}) : super(key: key);

  @override
  State<BaiaPage> createState() => BaiaPageState();
}

class BaiaPageState extends State<BaiaPage> {
  final OcupacaoBaiaTelaController _ocupacaoBaiaTelaController = OcupacaoBaiaTelaController();

  BaiaModel? _baia;
  OcupacaoModel? _ocupacao;
  
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await _carregarBaia();
    await _carregarOcupacao();
  }

  Future<void> _carregarBaia() async {   
    final baia = await _ocupacaoBaiaTelaController.fetchBaiaById(widget.baiaId!);  

    setState(() {
      _baia = baia;
    }); 
  }

  Future<void> _carregarOcupacao() async {   
    final ocupacao = await _ocupacaoBaiaTelaController.fetchLoteById(widget.baiaId!);
    
    setState(() {
      _ocupacao = ocupacao;
    }); 
  }

  void recarregarDados() async {
    await _carregarOcupacao();
  }

  @override
  Widget build(BuildContext context) {

    if (_baia == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text('Carregando...'),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text('Nº: ${_baia!.numero} - Código Ocupação: ${_ocupacao!.codigo}'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,            
            tabs: [
              Tab(
                text: 'Ações',
              ),
              Tab(
                text: 'Informações'
              ),
            ],
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white, // Highlighted tab color
                  width: 5.0, // Thickness of the border
                ),
              ),
            ),
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: TabBarView(
          children: [            
            CustomBaiaAcoesTabCard(baia: _baia!, ocupacao: _ocupacao, recarregarDados: recarregarDados),                    
            CustomBaiaInformacoesTabCard(ocupacao: _ocupacao),
          ],
        ),
      ),
    );
  }

}