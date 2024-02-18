import 'package:flutter/material.dart';
import 'package:mobile/components/cards/custom_baia_acao_card.dart';
import 'package:mobile/widgets/custom_add_anotacao_widget.dart';
import 'package:mobile/widgets/custom_adicionar_nascimento_widget.dart';
import 'package:mobile/widgets/custom_movimentar_animal_widget.dart';

class CustomBaiaAcoesTabCard extends StatefulWidget {
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
                Row(
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
                    },
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