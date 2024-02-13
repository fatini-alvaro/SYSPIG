import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_anotacao/cadastrar_anotacao_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_field_widget.dart';

class CadastrarAnotacaoPage extends StatefulWidget {
  @override
  State<CadastrarAnotacaoPage> createState() {
    return CadastrarAnotacaoPageState();
  }
}

class CadastrarAnotacaoPageState extends State<CadastrarAnotacaoPage> {
  final CadastrarAnotacaoController _cadastrarAnotacaoController =
      CadastrarAnotacaoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Anotação'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Selecionar Baia',
              onChanged: _cadastrarAnotacaoController.setBaia,
              obscureText: true,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Selecionar Animal',
              onChanged: _cadastrarAnotacaoController.setAnimal,
              obscureText: true,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Descrever Anotação',
              onChanged: _cadastrarAnotacaoController.setDescricao,
              obscureText: true,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros widgets aqui se necessário
                ],
              ),
            ),
            CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Anotação', rotaTelaAposSalvar:'selecionarAnotacao'),
          ],
        ),
      ),
    );
  }
}

