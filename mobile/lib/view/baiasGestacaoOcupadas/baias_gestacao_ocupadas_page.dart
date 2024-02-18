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
    _baiaController.fetch();
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
              caminhoTelaCadastro: 'abrirTelaCadastroBaia',
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
                      CustomBaiaCard(
                        numeroBaia: '01',
                        numeroBrincoBaia: '4524524',
                        statusBaia: 'O',
                        onTapCallback: () {
                          Navigator.of(context).pushNamed('/baiaGestacao');
                        },
                      ),
                      CustomBaiaCard(
                        numeroBaia: '02',
                        numeroBrincoBaia: '77411',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBaiaCard(
                        numeroBaia: '03',
                        numeroBrincoBaia: '4524524',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                      CustomBaiaCard(
                        numeroBaia: '04',
                        numeroBrincoBaia: '77411',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBaiaCard(
                        numeroBaia: '05',
                        numeroBrincoBaia: '4524524',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                      CustomBaiaCard(
                        numeroBaia: '06',
                        numeroBrincoBaia: '77411',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBaiaCard(
                        numeroBaia: '07',
                        numeroBrincoBaia: '4524524',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                      CustomBaiaCard(
                        numeroBaia: '08',
                        numeroBrincoBaia: '77411',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBaiaCard(
                        numeroBaia: '52482',
                        numeroBrincoBaia: '4524524',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
                      CustomBaiaCard(
                        numeroBaia: '11322',
                        numeroBrincoBaia: '77411',
                        statusBaia: 'O',
                        onTapCallback: () {
                          // 
                        },
                      ),
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
