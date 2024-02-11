import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/components/cards/custom_fazenda_registro_card.dart';
import 'package:mobile/controller/fazenda/fazenda_controller.dart';
import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/repositories/fazenda_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

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
    _fazendaController.fetch();
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
            child: CustomAbrirTelaAdicionarNovoButtonComponent(buttonText: 'Cadastrar Nova Fazenda'),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<FazendaModel>>(
              valueListenable: _fazendaController.fazendas,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomFazendaRegistroCard(
                    fazendaNome: list[idx].nome,
                    onEditarPressed: () {
                      // Lógica para abrir a tela de edição
                    },
                    onExcluirPressed: () {
                      // Lógica para excluir a fazenda
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
