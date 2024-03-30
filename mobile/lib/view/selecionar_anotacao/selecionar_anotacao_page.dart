import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/controller/anotacao/anotacao_controller.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class SelecionarAnotacaoPage extends StatefulWidget {
  @override
  State<SelecionarAnotacaoPage> createState() {
    return SelecionarAnotacaoPageState();
  }
}

class SelecionarAnotacaoPageState extends State<SelecionarAnotacaoPage> {
  
  final AnotacaoController _anotacaoController = AnotacaoController(AnotacaoRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _anotacaoController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Anotações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Anotação', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroAnotacao');     
              },
            ),
          ),
          SizedBox(height: 15),
          // Expanded(
          //   child: ValueListenableBuilder<List<GranjaModel>>(
          //     valueListenable: _granjaController.granjas,
          //     builder: (_, list, __) {
          //       return ListView.builder(
          //         itemCount: list.length,
          //         itemBuilder: (_, idx) => CustomRegistroCard(
          //           granja: list[idx],
          //           onEditarPressed: () {
          //             // Lógica para abrir a tela de edição
          //           },
          //           onExcluirPressed: () {
          //             // Lógica para excluir
          //           },
          //           caminhoTelaAoClicar: 'home'
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
