import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/components/cards/custom_granja_registro_card.dart';
import 'package:mobile/controller/granja/granja_controller.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/repositories/granja/granja_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class SelecionarGranjaPage extends StatefulWidget {
  @override
  State<SelecionarGranjaPage> createState() {
    return SelecionarGranjaPageState();
  }
}

class SelecionarGranjaPageState extends State<SelecionarGranjaPage> {
  
  final GranjaController _granjaController = GranjaController(GranjaRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _granjaController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Selecione a granja'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Granja', 
              caminhoTelaCadastro: 'abrirTelaCadastroGranja',
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<GranjaModel>>(
              valueListenable: _granjaController.granjas,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomGranjaRegistroCard(
                    granja: list[idx],
                    onEditarPressed: () {
                      // Lógica para abrir a tela de edição
                    },
                    onExcluirPressed: () {
                      // Lógica para excluir
                    },
                    caminhoTelaAoClicar: 'home'
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
