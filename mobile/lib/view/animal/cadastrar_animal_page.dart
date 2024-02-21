import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_animal/cadastrar_animal_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_field_widget.dart';

class CadastrarAnimalPage extends StatefulWidget {
  @override
  State<CadastrarAnimalPage> createState() {
    return CadastrarAnimalPageState();
  }
}

class CadastrarAnimalPageState extends State<CadastrarAnimalPage> {
  final CadastrarAnimalController _cadastrarAnimalController =
      CadastrarAnimalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Animal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Numero do Brinco',
              onChanged: _cadastrarAnimalController.setNumeroBrinco,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Sexo',
              onChanged: _cadastrarAnimalController.setSexo,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Status',
              onChanged: _cadastrarAnimalController.setStatus,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Data de Nascimento',
              onChanged: _cadastrarAnimalController.setNascimento,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros widgets aqui se necessário
                ],
              ),
            ),
            CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Animal', rotaTelaAposSalvar:'selecionarAnimal'),
          ],
        ),
      ),
    );
  }
}

