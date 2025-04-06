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
  final Future<void> Function()? recarregarDados;

  const CustomBaiaAcoesTabCard({Key? key, this.ocupacao, this.baia, this.recarregarDados}) : super(key: key);

  @override
  _CustomBaiaAcoesTabCardState createState() => _CustomBaiaAcoesTabCardState();
}

class _CustomBaiaAcoesTabCardState extends State<CustomBaiaAcoesTabCard> with SingleTickerProviderStateMixin {
  bool isAddingAnotacao = false;
  bool isAddingBorn = false;

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
              onClose: () async {
                Navigator.pop(context);
                try {
                  await widget.recarregarDados?.call();

                  if (mounted) {
                    setState(() {});
                  }

                  if (widget.baia?.vazia == true) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Baia foi encerrada pois está vazia.')),
                        );
                      }
                    });

                    Future.delayed(Duration(milliseconds: 400), () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    });
                  }
                } catch (e) {
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao recarregar dados: $e')),
                    );
                  }
                }
              }
            ),
          ),
        ),
      ),
    );
  }

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

}