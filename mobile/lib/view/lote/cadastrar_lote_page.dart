import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_lote/cadastrar_lote_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarLotePage extends StatefulWidget {
  @override
  State<CadastrarLotePage> createState() {
    return CadastrarLotePageState();
  }
}

class CadastrarLotePageState extends State<CadastrarLotePage> {
  final CadastrarLoteController _cadastrarLoteController =
      CadastrarLoteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Lote'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextFormFieldWidget(
              label: 'Numero Lote',
              onChanged: _cadastrarLoteController.setNumero
            ),
            SizedBox(height: 20),
            CustomTextFormFieldWidget(
              label: 'Selecionar Animal',
              onChanged: _cadastrarLoteController.setAnimal
            ),
            Expanded(
              child: ListView(
                children: [
                  // 
                ],
              ),
            ),
            CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Lote', rotaTelaAposSalvar:'selecionarLote'),
          ],
        ),
      ),
    );
  }
}

