import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_registro_card.dart';
import 'package:syspig/controller/granja/granja_controller.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/granja/granja_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/granja/cadastrar_granja_page.dart';
import 'package:syspig/view/selecionar_baia/selecionar_baia_page.dart';

class SelecionarGranjaPage extends StatefulWidget {
  @override
  State<SelecionarGranjaPage> createState() {
    return SelecionarGranjaPageState();
  }
}

class SelecionarGranjaPageState extends State<SelecionarGranjaPage> {
  
  final GranjaController _granjaController = GranjaController(GranjaRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarGranjas();
  }

  Future<void> _carregarGranjas() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _granjaController.fetch(fazendaId);
    } else {
      print('ID da fazenda não encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Selecione a granja'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Granja', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroGranja');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<GranjaModel>>(
              valueListenable: _granjaController.granjas,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomRegistroCard(
                    descricao: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[idx].descricao,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tipo - ${list[idx].tipoGranja?.descricao}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.landscape, // Ícone de localização (substitua pelo ícone desejado)
                              color: Colors.red, // Cor do ícone (ajuste conforme necessário)
                            ),
                            SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                            Text(
                              'Fazenda - ${list[idx].fazenda?.nome}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12), // Espaço para a dica
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down, // Ícone de seta para baixo
                              color: Colors.grey, // Cor do ícone de seta
                            ),
                            SizedBox(width: 4), // Espaço entre a seta e o texto
                            Text(
                              'Clique para ver as baias', // Dica para o usuário
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black, // Cor do texto da dica
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onEditarPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastrarGranjaPage(
                            granjaParaEditar: list[idx],
                          ),
                        ),
                      );
                    },
                    onExcluirPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Confirmar exclusão'),
                          content: Text('Tem certeza de que deseja excluir a granja ${list[idx].descricao}?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Fechar o diálogo de confirmação
                                await _granjaController.delete(context, list[idx].id!);

                                Dialogs.successToast(context, 'Granja excluída com sucesso!');
                                _carregarGranjas();
                              },
                              child: Text('Confirmar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Fechar o diálogo de confirmação
                              },
                              child: Text('Cancelar'),
                            ),
                          ],
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelecionarBaiaPage(granja: list[idx]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
