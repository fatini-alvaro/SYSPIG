import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_baia_acao_card.dart';
import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/widgets/custom_add_anotacao_widget.dart';
import 'package:syspig/widgets/custom_adicionar_nascimento_widget.dart';
import 'package:syspig/widgets/custom_movimentar_animal_widget.dart';

class CustomBaiaAcoesTabCard extends StatefulWidget {

  final OcupacaoModel? ocupacao;
  final BaiaModel? baia;
  final VoidCallback? recarregarDados;

  CustomBaiaAcoesTabCard({Key? key, this.ocupacao, this.baia, this.recarregarDados}) : super(key: key);

  @override
  _CustomBaiaAcoesTabCardState createState() => _CustomBaiaAcoesTabCardState();
}

class _CustomBaiaAcoesTabCardState extends State<CustomBaiaAcoesTabCard> with SingleTickerProviderStateMixin {
  bool isAddingAnotacao = false;
  bool isMakeMovimentation = false;
  bool isAddingBorn = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !isAddingAnotacao && !isMakeMovimentation && !isAddingBorn,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CustomBaiaAcaoCard(
                      descricao: 'Criar Anotação',
                      icone: Icons.note_alt_outlined,
                      onTapCallback: () {
                        setState(() {
                          isAddingAnotacao = true;
                          isMakeMovimentation = false;
                          isAddingBorn = false;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CustomBaiaAcaoCard(
                      descricao: 'Movimentar',
                      icone: Icons.compare_arrows,
                      onTapCallback: () {
                        setState(() {
                          isMakeMovimentation = true;
                          isAddingAnotacao = false;
                          isAddingBorn = false;
                        });
                      },
                    ),
                  ],
                ),
                if(widget.baia?.granja?.tipoGranja?.id == tipoGranjaIdToInt[TipoGranjaId.gestacao])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomBaiaAcaoCard(
                      descricao: 'Nascimento',
                      icone: Icons.child_friendly_outlined,
                      onTapCallback: () {
                        setState(() {
                          isAddingBorn = true;
                          isAddingAnotacao = false;
                          isMakeMovimentation = false;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                  ],
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
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            isAddingAnotacao = false;
                          });
                        },
                      ),
                      // Add other icons or widgets as needed
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomAddAnotacaoWidget(
                    onClose: () {
                      setState(() {
                        isAddingAnotacao = false;
                      });
                      // Recarregar os dados após salvar a anotação
                      if (widget.recarregarDados != null) {
                        widget.recarregarDados!();
                      }
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
          visible: isMakeMovimentation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            isMakeMovimentation = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomMovimentarAnimalWidget(
                    onClose: () {
                      setState(() {
                        isMakeMovimentation = false;
                      });
                    },
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
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            isAddingBorn = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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