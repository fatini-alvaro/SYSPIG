import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syspig/components/cards/custom_home_card.dart';

class AcoesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomHomeCard(
                descricao: 'Baias',
                icone: Icons.panorama_horizontal_select_outlined,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarBaia');
                },
              ),
              CustomHomeCard(
                descricao: 'Movimentação',
                icone: Icons.compare_arrows,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarMovimentacao');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CustomHomeCard(
                descricao: 'Granjas',
                icone: Icons.house_siding,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarGranja');
                },
              ),
              CustomHomeCard(
                descricao: 'Animais',
                icone: FontAwesomeIcons.piggyBank,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarAnimal');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomHomeCard(
                descricao: 'Anotações',
                icone: Icons.note_alt_outlined,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarAnotacao');
                },
              ),
              SizedBox(height: 20),
              CustomHomeCard(
                descricao: 'lotes',
                icone: Icons.note,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarLote');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CustomHomeCard(
                descricao: 'Inseminação',
                icone: Icons.vaccines,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/selecionarInseminacao');
                },
              ),
              SizedBox(height: 20),
              CustomHomeCard(
                descricao: 'Vender Leitões',
                icone: Icons.sell,
                onTapCallback: () {
                  Navigator.of(context).pushNamed('/visualizarVenda');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
