import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_inseminacao_card.dart';
import 'package:syspig/controller/inseminacao/inseminacao_controller.dart';
import 'package:syspig/model/inseminacao_model.dart';
import 'package:syspig/repositories/iseminacao/inseminacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';

class SelecionarInseminacaoPage extends StatefulWidget {
  @override
  State<SelecionarInseminacaoPage> createState() {
    return SelecionarInseminacaoPageState();
  }
}

class SelecionarInseminacaoPageState extends State<SelecionarInseminacaoPage> {
  
  final InseminacaoController _inseminacaoController = InseminacaoController(InseminacaoRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarInseminacoes();
  }

  Future<void> _carregarInseminacoes() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _inseminacaoController.fetch(fazendaId);
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
        title: Text('Inseminações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova inseminação',
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroInseminacao');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<InseminacaoModel>>(
              valueListenable: _inseminacaoController.inseminacoes,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomInseminacaoCard(
                    inseminacao: list[idx],      
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
