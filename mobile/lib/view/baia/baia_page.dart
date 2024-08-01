import 'package:flutter/material.dart';
import 'package:mobile/components/cards/custom_baia_acoes_tab_card.dart';
import 'package:mobile/components/cards/custom_baia_informacoes_tab_card.dart';
import 'package:mobile/controller/anotacao/anotacao_controller.dart';
import 'package:mobile/model/ocupacao_model.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class BaiaPage extends StatefulWidget {

  final OcupacaoModel? ocupacao;

  BaiaPage({Key? key, this.ocupacao}) : super(key: key);

  @override
  State<BaiaPage> createState() {
    return BaiaPageState();
  }
}

class BaiaPageState extends State<BaiaPage> {
  final AnotacaoController _anotacaoController = AnotacaoController(AnotacaoRepositoryImp());

  @override
  void initState() {
    super.initState();
    _carregarAnotacoes();
  }

  Future<void> _carregarAnotacoes() async {   
    _anotacaoController.getAnotacoesByBaia(widget.ocupacao!.baia!.id!);   
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text('Baia - ${widget.ocupacao!.baia!.numero}   Animal - ${widget.ocupacao!.animal!.numeroBrinco}'),
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
            CustomBaiaInformacoesTabCard(ocupacao: widget.ocupacao),
          ],
        ),
      ),
    );
  }

}