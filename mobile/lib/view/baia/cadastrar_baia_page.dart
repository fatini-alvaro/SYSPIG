import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_baia/cadastrar_baia_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarBaiaPage extends StatefulWidget {
  @override
  State<CadastrarBaiaPage> createState() {
    return CadastrarBaiaPageState();
  }
}

class CadastrarBaiaPageState extends State<CadastrarBaiaPage> {
  final CadastrarBaiaController _cadastrarBaiaController =
      CadastrarBaiaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Baia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFormFieldWidget(
              label: 'Numero da Baia',
              onChanged: _cadastrarBaiaController.setNumero,              
            ),
            SizedBox(height: 20),
            CustomTextFormFieldWidget(
              label: 'Granja',
              onChanged: _cadastrarBaiaController.setGranja,
            ),
            SizedBox(height: 20),            
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros widgets aqui se necessário
                ],
              ),
            ),
            CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Baia', rotaTelaAposSalvar:'selecionarBaia'),
          ],
        ),
      ),
    );
  }
}

