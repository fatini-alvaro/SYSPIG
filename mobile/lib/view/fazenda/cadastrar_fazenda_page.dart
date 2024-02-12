import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/components/cards/custom_fazenda_registro_card.dart';
import 'package:mobile/controller/fazenda/fazenda_controller.dart';
import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/repositories/fazenda_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class CadastrarFazendaPage extends StatefulWidget {
  @override
  State<CadastrarFazendaPage> createState() {
    return CadastrarFazendaPageState();
  }
}

class CadastrarFazendaPageState extends State<CadastrarFazendaPage> {
  
  //  final FazendaController _fazendaController = FazendaController(FazendaRepositoryImp());
  // @override
  // void initState() {
  //   super.initState();
  //   _fazendaController.fetch();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Fazenda'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          
        ],
      ),
    );
  }
}
