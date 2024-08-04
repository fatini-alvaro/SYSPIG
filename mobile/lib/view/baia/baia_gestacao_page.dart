import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_baia_acoes_tab_card.dart';
import 'package:syspig/components/cards/custom_baia_informacoes_tab_card.dart';
import 'package:syspig/themes/themes.dart';

class BaiaGestacaoPage extends StatefulWidget {
  @override
  State<BaiaGestacaoPage> createState() {
    return BaiaGestacaoPageState();
  }
}

class BaiaGestacaoPageState extends State<BaiaGestacaoPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text('Baia - 01'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,            
            tabs: [
              Tab(
                text: 'Ações',
              ),
              Tab(
                text: 'Informações'
              ),
            ],
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white, // Highlighted tab color
                  width: 5.0, // Thickness of the border
                ),
              ),
            ),
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: TabBarView(
          children: [            
            CustomBaiaAcoesTabCard(),                    
            CustomBaiaInformacoesTabCard(),
          ],
        ),
      ),
    );
  }

}