import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/components/cards/custom_baia_card.dart';
import 'package:mobile/controller/baia/baia_controller.dart';
import 'package:mobile/repositories/baia/baia_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class BaiasGestacaoOcupadasPage extends StatefulWidget {
  @override
  State<BaiasGestacaoOcupadasPage> createState() {
    return BaiasGestacaoOcupadasPageState();
  }
}

class BaiasGestacaoOcupadasPageState extends State<BaiasGestacaoOcupadasPage> {
  
  final BaiaController _baiaController = BaiaController(BaiaRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _baiaController.fetch(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Porcas em Gestação'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Baia', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroBaia');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
