import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/controller/anotacao/anotacao_controller.dart';
import 'package:mobile/controller/lote/lote_controller.dart';
import 'package:mobile/repositories/lote/lote_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class SelecionarLotePage extends StatefulWidget {
  @override
  State<SelecionarLotePage> createState() {
    return SelecionarLotePageState();
  }
}

class SelecionarLotePageState extends State<SelecionarLotePage> {
  
  final LoteController _loteController = LoteController(LoteRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _loteController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Lotes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Novo Lote', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroLote');     
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
