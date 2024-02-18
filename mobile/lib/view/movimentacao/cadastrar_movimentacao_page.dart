import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_movimentacao/cadastrar_movimentacao_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/utils/dialogs.dart';

class CadastrarMovimentacaoPage extends StatefulWidget {
  @override
  State<CadastrarMovimentacaoPage> createState() => CadastrarAnotacaoPageState();
}

class CadastrarAnotacaoPageState extends State<CadastrarMovimentacaoPage> {
  final CadastrarMovimentacaoController _cadastrarMovimentacaoController = CadastrarMovimentacaoController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Aterar para o tipo do que vai ser carregado
  List<String> granjas = [
    'Granja A',
    'Granja B',
    'Granja C',
    'Granja D',
    // Adicione suas granjas carregadas do banco de dados aqui
  ];

  List<String> baia = [
    'Baia A',
    'Baia B',
    'Baia C',
    'Baia D',
    // Adicione suas baias carregadas do banco de dados aqui
  ];

  String selectedBaia = '';
  String selectedGranja = '';
  bool showDetails = false; // Variável para controlar a exibição do card de detalhes

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBaiaAtual(),
                _buildMovimentarPara(),
                _buildSelecionarGranja(),
                _buildSelecionarBaia(),
                _buildSalvarButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBaiaAtual() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Baia Atual: ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Material(
              elevation: 4,
              shape: CircleBorder(),
              color: Colors.orange,
              child: Container(width: 50, height: 50,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: Text('3', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity, // Define a largura do botão para ocupar toda a largura disponível
          height: 50, // Define a altura do botão
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showDetails = !showDetails; // Alterna a exibição do card de detalhes
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Define a cor de fundo do botão
              foregroundColor: Colors.white, // Define a cor do texto do botão
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child:
                Text(showDetails ? 'Esconder Detalhes' : 'Visualizar Detalhes'),
          ),
        ),
        if (showDetails) // Exibe o card de detalhes somente se showDetails for verdadeiro
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome da Granja', style: TextStyle(fontSize: 18)),
                  Divider(color: Colors.grey,thickness: 1),
                  Text('Informações:',style: TextStyle(fontSize: 15)),
                  Text('Data de Entrada: 22/11/2023', style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMovimentarPara() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text('Movimentar para: ',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildSelecionarGranja() {
    return SizedBox(
      height: 80,
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return granjas.where((String option) {
            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          setState(() {
            selectedGranja = selection;
          });
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            decoration: InputDecoration(
              labelText: 'Selecionar Granja',
              border: OutlineInputBorder(),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelecionarBaia() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0), // Adicionando um padding top de 16.0
      child: SizedBox(
        height: 80,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return baia.where((String option) {
              return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
            });
          },
          onSelected: (String selection) {
            setState(() {
              selectedBaia = selection;
            });
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
              decoration: InputDecoration(
                labelText: 'Selecionar Baia',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSalvarButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        CustomSalvarCadastroButtonComponent(
          buttonText: 'Salvar movimentação',
          rotaTelaAposSalvar: 'selecionarMovimentacao',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Execute a ação de salvar
            }
          },
        ),
      ],
    );
  }
}

