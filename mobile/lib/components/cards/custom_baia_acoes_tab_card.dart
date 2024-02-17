import 'package:flutter/material.dart';
import 'package:mobile/components/cards/custom_baia_acao_card.dart';
import 'package:mobile/widgets/custom_add_anotacao_widget.dart';

class CustomBaiaAcoesTabCard extends StatefulWidget {
  @override
  _CustomBaiaAcoesTabCardState createState() => _CustomBaiaAcoesTabCardState();
}

class _CustomBaiaAcoesTabCardState extends State<CustomBaiaAcoesTabCard> with SingleTickerProviderStateMixin {
  bool isAddingAnotacao = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !isAddingAnotacao,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    CustomBaiaAcaoCard(
                      descricao: 'Criar Anotação',
                      icone: Icons.note_alt_outlined,
                      onTapCallback: () {
                        setState(() {
                          isAddingAnotacao = true;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CustomBaiaAcaoCard(
                      descricao: 'Movimentar',
                      icone: Icons.compare_arrows,
                      onTapCallback: () {
                        // Handle Movimentar
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
                  CustomAddAnotacaoWidget(
                    onClose: () {
                      setState(() {
                        isAddingAnotacao = false;
                      });
                    },
                  ),
                ] 
              ),
            ),
          ),
        ),
      ],
    );
  }
}