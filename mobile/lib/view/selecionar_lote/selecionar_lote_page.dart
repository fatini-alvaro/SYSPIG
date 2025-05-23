import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_registro_card.dart';
import 'package:syspig/controller/lote/lote_controller.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/lote/lote_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';
import 'package:logger/logger.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/lote/cadastrar_lote_page.dart';

class SelecionarLotePage extends StatefulWidget {
  @override
  State<SelecionarLotePage> createState() {
    return SelecionarLotePageState();
  }
}

class SelecionarLotePageState extends State<SelecionarLotePage> {
  
  final LoteController _loteController = LoteController(LoteRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarLotes();
  }

  Future<void> _carregarLotes() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _loteController.fetch(fazendaId);
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
        title: Text('Lotes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Novo Lote', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroLote');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<LoteModel>>(
              valueListenable: _loteController.lotes,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomRegistroCard(
                    descricao: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Número: ${list[idx].numeroLote}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Descrição: ${list[idx].descricao}',
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
                          builder: (context) => CadastrarLotePage(
                            loteId: list[idx].id,
                          ),
                        ),
                      );
                    },
                    onExcluirPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Confirmar exclusão'),
                          content: Text('Tem certeza de que deseja excluir o lote?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  Navigator.pop(context);

                                  bool excluido = await _loteController.delete(list[idx].id!);

                                  if (excluido) {
                                    Dialogs.successToast(context, 'Lote excluído com sucesso!');
                                    _carregarLotes();
                                  } else {
                                    Dialogs.errorToast(context, 'Falha ao excluir lote');
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
                                Navigator.pop(context); // Fechar o diálogo de confirmação
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
