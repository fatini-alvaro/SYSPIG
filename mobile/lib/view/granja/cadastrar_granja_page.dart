import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_granja/cadastrar_granja_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarGranjaPage extends StatefulWidget {
  @override
  State<CadastrarGranjaPage> createState() {
    return CadastrarGranjaPageState();
  }
}

class CadastrarGranjaPageState extends State<CadastrarGranjaPage> {
  final CadastrarGranjaController _cadastrarGranjaController =
      CadastrarGranjaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Granja'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFormFieldWidget(
              label: 'Nome da Granja',
              onChanged: _cadastrarGranjaController.setDescricao,
            ),
            SizedBox(height: 20),
            CustomTextFormFieldWidget(
              label: 'Tipo Da Granja',
              onChanged: _cadastrarGranjaController.setTipoGranja,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros widgets aqui se necessário
                ],
              ),
            ),
            CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Granja', rotaTelaAposSalvar:'selecionarGranja'),
          ],
        ),
      ),
    );
  }
}

