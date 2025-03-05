import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_fazenda_registro_card.dart';
import 'package:syspig/controller/fazenda/fazenda_controller.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/repositories/fazenda/fazenda_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';

class SelecionarFazendaPage extends StatefulWidget {
  @override
  State<SelecionarFazendaPage> createState() {
    return SelecionarFazendaPageState();
  }
}

class SelecionarFazendaPageState extends State<SelecionarFazendaPage> {
  
  final FazendaController _fazendaController = FazendaController(FazendaRepositoryImp());
  
  @override
  void initState() {
    super.initState();
    _carregarFazendas();
  }

  Future<void> _carregarFazendas() async {
    int? userId = await PrefsService.getUserId();
    if (userId != null) {
      _fazendaController.fetch(userId);
    } else {
      // Tratar caso em que o ID do usuário não foi encontrado
      Logger().e('ID do usuário não encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Selecione a fazenda'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Fazenda', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroFazenda');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<FazendaModel>>(
              valueListenable: _fazendaController.fazendas,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomFazendaRegistroCard(
                    fazenda: list[idx],
                    onTapCallback: () {
                      _fazendaController.selecionaFazenda(list[idx]);
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
