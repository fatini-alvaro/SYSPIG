import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_movimentacao_card.dart';
import 'package:syspig/components/cards/custom_registro_card.dart';
import 'package:syspig/controller/animal/animal_controller.dart';
import 'package:syspig/controller/movimentacao/movimentacao_controller.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/animal/cadastrar_animal_page.dart';

class SelecionarMovimentacaoPage extends StatefulWidget {
  @override
  State<SelecionarMovimentacaoPage> createState() {
    return SelecionarMovimentacaoPageState();
  }
}

class SelecionarMovimentacaoPageState extends State<SelecionarMovimentacaoPage> {
  
  final MovimentacaoController _movimentacaoController = MovimentacaoController(MovimentacaoRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarMovimentacoes();
  }

  Future<void> _carregarMovimentacoes() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _movimentacaoController.fetch(fazendaId);
    } else {
      Logger().e('ID da fazenda não encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Movimentar Animais'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Movimentação', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroMovimentacao');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<MovimentacaoModel>>(
              valueListenable: _movimentacaoController.movimentacoes,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomMovimentacaoCard(
                    movimentacao: list[idx],      
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
