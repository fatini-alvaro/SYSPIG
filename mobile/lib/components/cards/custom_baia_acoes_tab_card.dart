import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syspig/components/cards/custom_baia_acao_card.dart';
import 'package:syspig/controller/cadastrar_movimentacao_baia/cadastrar_movimentacao_baia_controller.dart';
import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/widgets/custom_add_anotacao_widget.dart';
import 'package:syspig/widgets/custom_add_movimentacao_baia_widget.dart';
import 'package:syspig/widgets/custom_adicionar_nascimento_widget.dart';

class CustomBaiaAcoesTabCard extends StatefulWidget {
  final OcupacaoModel? ocupacao;
  final BaiaModel? baia;
  final VoidCallback? recarregarDados;

  const CustomBaiaAcoesTabCard({Key? key, this.ocupacao, this.baia, this.recarregarDados}) : super(key: key);

  @override
  _CustomBaiaAcoesTabCardState createState() => _CustomBaiaAcoesTabCardState();
}

class _CustomBaiaAcoesTabCardState extends State<CustomBaiaAcoesTabCard> with SingleTickerProviderStateMixin {
  bool isAddingAnotacao = false;
  bool isAddingBorn = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !isAddingAnotacao && !isAddingBorn,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomBaiaAcaoCard(
                      descricao: 'Criar Anotação',
                      icone: Icons.note_alt_outlined,
                      onTapCallback: () {
                        setState(() {
                          isAddingAnotacao = true;
                          isAddingBorn = false;
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomBaiaAcaoCard(
                      descricao: 'Movimentar',
                      icone: Icons.compare_arrows,
                      onTapCallback: _abrirDialogMovimentacao,
                    ),
                  ],
                ),
                if (widget.baia?.granja?.tipoGranja?.id == tipoGranjaIdToInt[TipoGranjaId.gestacao])
                const SizedBox(height: 20),
                if (widget.baia?.granja?.tipoGranja?.id == tipoGranjaIdToInt[TipoGranjaId.gestacao])
                CustomBaiaAcaoCard(
                  descricao: 'Nascimento',
                  icone: Icons.child_friendly_outlined,
                  onTapCallback: () {
                    setState(() {
                      isAddingBorn = true;
                      isAddingAnotacao = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isAddingAnotacao,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            isAddingAnotacao = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomAddAnotacaoWidget(
                    onClose: () {
                      setState(() {
                        isAddingAnotacao = false;
                      });
                      widget.recarregarDados?.call();
                    },
                    ocupacao: widget.ocupacao!,
                    baia: widget.baia!,
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isAddingBorn,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            isAddingBorn = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomAdicionarNascimentoWidget(
                    onClose: () {
                      setState(() {
                        isAddingBorn = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _abrirDialogMovimentacao() {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => MovimentacaoBaiaController()..loadBaias(),
        child: AlertDialog(
          title: const Text('Movimentar Animais'),
          content: SizedBox(
            width: double.maxFinite,
            child: CustomMovimentacaoBaiaWidget(
              ocupacao: widget.ocupacao!,
              baia: widget.baia!,
              onClose: () => Navigator.pop(context),
              onMovimentarTodosParaMesmaBaia: (baiaDestino) async {
                // Implementar lógica para todos os animais
                for (var oa in widget.ocupacao!.ocupacaoAnimais!) {
                  // await _movimentarAnimal(oa.animal!, baiaDestino);
                }
                Navigator.pop(context);
                widget.recarregarDados?.call();
              },
              onMovimentarSelecionadosParaMesmaBaia: (animais, baiaDestino) async {
                // Implementar lógica para animais selecionados
                for (var animal in animais) {
                  // await _movimentarAnimal(animal, baiaDestino);
                }
                Navigator.pop(context);
                widget.recarregarDados?.call();
              },
              onMovimentarParaBaiasDiferentes: (animalBaiaMap) async {
                // Implementar lógica para cada animal em baia diferente
                for (var entry in animalBaiaMap.entries) {
                  // await _movimentarAnimal(entry.key, entry.value);
                }
                Navigator.pop(context);
                widget.recarregarDados?.call();
              },
            ),
          ),
        ),
      ),
    );
  }
}