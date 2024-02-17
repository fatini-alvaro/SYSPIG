import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_movimentacao/cadastrar_movimentacao_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_field_widget.dart';

class CadastrarMovimentacaoPage extends StatefulWidget {
  @override
  State<CadastrarMovimentacaoPage> createState() {
    return CadastrarAnotacaoPageState();
  }
}

class CadastrarAnotacaoPageState extends State<CadastrarMovimentacaoPage> {
  final CadastrarMovimentacaoController _cadastrarMovimentacaoController =
      CadastrarMovimentacaoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Movimentação'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Baia Atual: ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Material(
                  elevation: 4, // Elevação do círculo laranja
                  shape: CircleBorder(),
                  color: Colors.orange,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '3', // Número dentro do círculo
                        style: TextStyle(
                          color:
                              Colors.white, // Cor do número dentro do círculo
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome da Granja',
                          style: TextStyle(fontSize: 18),
                        ),
                        // Adicionando um espaço entre o texto e a linha
                        Divider(
                          // Adicionando uma linha
                          color: Colors.grey, // Cor da linha
                          thickness: 1, // Espessura da linha
                        ),
                        Text(
                          'Informações:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Data de Entrada: 22/11/2023',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 20), // Espaçamento de 20 pixels
                Text(
                  'Movimentar para: ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                // Outros widgets podem ser adicionados abaixo
              ],
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Selecionar Granja',
              onChanged: _cadastrarMovimentacaoController.setGranja,
            ),
            SizedBox(height: 20),
            CustomTextFieldWidget(
              label: 'Selecionar Baia',
              onChanged: _cadastrarMovimentacaoController.setBaia,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros widgets aqui se necessário
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                CustomSalvarCadastroButtonComponent(
                  buttonText: 'Salvar movimentação',
                  rotaTelaAposSalvar: 'selecionarMovimentacao',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
