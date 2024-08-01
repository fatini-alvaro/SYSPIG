import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/controller/movimentacao/movimentacao_controller.dart';
import 'package:mobile/repositories/movimentacao/movimentacao_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

class SelecionarMovimentacaoPage extends StatefulWidget {
  @override
  State<SelecionarMovimentacaoPage> createState() {
    return SelecionarMovimentacaoPageState();
  }
}

class SelecionarMovimentacaoPageState extends State<SelecionarMovimentacaoPage> {
  final MovimentacaoController _movimentacaoController = MovimentacaoController(MovimentacaoRepositoryImp());

  @override
  void initState() {
    super.initState();
    _movimentacaoController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Movimentações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 4, // Define o nível de elevação para criar o efeito de sombra
              borderRadius: BorderRadius.circular(5), // Bordas arredondadas do Material
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 248), // Cor de fundo do campo de pesquisa
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ), // Borda arredondada apenas nos cantos esquerdos
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none, // Sem borda
                            hintText: 'Pesquisar',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(193, 208, 205, 205)), // Cor do texto de dica
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ), // Borda arredondada apenas nos cantos direitos
                    color: Colors.orange, // Cor de fundo do botão de pesquisa
                    child: InkWell(
                      onTap: () {
                        // Adicione aqui a lógica para a pesquisa
                      },
                      child: Padding(
                        padding: EdgeInsets.all(13),
                        child: Icon(Icons.search, color: Colors.white), // Ícone de pesquisa branco
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //--------
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Movimentacao',
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroMovimentacao');     
              },
            ),
          ),
          SizedBox(height: 15),
          // Expanded(
          //   child: ValueListenableBuilder<List<GranjaModel>>(
          //     valueListenable: _granjaController.granjas,
          //     builder: (_, list, __) {
          //       return ListView.builder(
          //         itemCount: list.length,
          //         itemBuilder: (_, idx) => CustomRegistroCard(
          //           granja: list[idx],
          //           onEditarPressed: () {
          //             // Lógica para abrir a tela de edição
          //           },
          //           onExcluirPressed: () {
          //             // Lógica para excluir
          //           },
          //           caminhoTelaAoClicar: 'home'
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}