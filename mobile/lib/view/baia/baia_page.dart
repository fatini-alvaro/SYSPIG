import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_baia_acoes_tab_card.dart';
import 'package:syspig/components/cards/custom_baia_informacoes_tab_card.dart';
import 'package:syspig/controller/anotacao/anotacao_controller.dart';
import 'package:syspig/controller/baia/baia_controller.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/themes/themes.dart';

class BaiaPage extends StatefulWidget {
  final int? baiaId;

  BaiaPage({Key? key, this.baiaId}) : super(key: key);

  @override
  State<BaiaPage> createState() => BaiaPageState();
}


class BaiaPageState extends State<BaiaPage> {
  final AnotacaoController _anotacaoController = AnotacaoController(AnotacaoRepositoryImp());
  final BaiaController _baiaController = BaiaController(BaiaRepositoryImp());

  BaiaModel? _baia;
  
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await _carregarBaia();
  }

  Future<void> _carregarBaia() async {   
    final baia = await _baiaController.fetchBaiaById(widget.baiaId!);  

    setState(() {
      _baia = baia;
    }); 
  }

  Future<void> _carregarAnotacoes() async {   
    _anotacaoController.getAnotacoesByBaia(widget.baiaId!);   
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
          title: Text('Baia - ${_baia!.numero}   Animal - ${_baia!.ocupacao!.animal!.numeroBrinco}'),
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
            CustomBaiaAcoesTabCard(),                    
            CustomBaiaInformacoesTabCard(ocupacao: _baia!.ocupacao),
          ],
        ),
      ),
    );
  }

}