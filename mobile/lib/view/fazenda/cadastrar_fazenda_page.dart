import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_fazenda/cadastrar_fazenda_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_field_widget.dart';

class CadastrarFazendaPage extends StatefulWidget {
  @override
  State<CadastrarFazendaPage> createState() {
    return CadastrarFazendaPageState();
  }
}

class CadastrarFazendaPageState extends State<CadastrarFazendaPage> {
  final CadastrarFazendaController _cadastrarFazendaController =
      CadastrarFazendaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Fazenda'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Nome da Fazenda',
              onChanged: _cadastrarFazendaController.setNome,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Cidade',
              onChanged: _cadastrarFazendaController.setCidade,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros widgets aqui se necessário
                ],
              ),
            ),
            CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Fazenda', rotaTelaAposSalvar:'selecionarFazenda'),
          ],
        ),
      ),
    );
  }
}

