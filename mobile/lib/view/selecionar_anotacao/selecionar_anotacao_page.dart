import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_registro_card.dart';
import 'package:syspig/controller/anotacao/anotacao_controller.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/anotacao/cadastrar_anotacao_page.dart';

class SelecionarAnotacaoPage extends StatefulWidget {
  @override
  State<SelecionarAnotacaoPage> createState() {
    return SelecionarAnotacaoPageState();
  }
}

class SelecionarAnotacaoPageState extends State<SelecionarAnotacaoPage> {
  
  final AnotacaoController _anotacaoController = AnotacaoController(AnotacaoRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarAnotacoes();
  }

  Future<void> _carregarAnotacoes() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _anotacaoController.fetch(fazendaId);
    } else {
      Logger().e('ID da fazenda não encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Anotações'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Anotação', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroAnotacao');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<AnotacaoModel>>(
              valueListenable: _anotacaoController.anotacoes,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomRegistroCard(
                    descricao: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descricao: ${list[idx].descricao}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    onEditarPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastrarAnotacaoPage(
                            anotacaoId: list[idx].id,
                          ),
                        ),
                      );
                    },
                    onExcluirPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Confirmar exclusão'),
                          content: Text('Tem certeza de que deseja excluir a anotação?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  Navigator.pop(context);

                                  bool excluido = await _anotacaoController.delete(list[idx].id!);

                                  if (excluido) {
                                    Dialogs.successToast(context, 'Anotação excluída com sucesso!');
                                    _carregarAnotacoes();
                                  } else {
                                    Dialogs.errorToast(context, 'Falha ao excluir a Anotação');
                                  }
                                } catch (e) {
                                  String errorMessage = e.toString().replaceFirst('Exception: ', '');
                                  Dialogs.errorToast(context, errorMessage);
                                }
                              },
                              child: Text('Confirmar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                          ],
                        ),
                      );
                    },   
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
