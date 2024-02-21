import 'package:flutter/material.dart';
import 'package:mobile/components/cards/custom_pre_visualizacao_anotacao_card.dart';

class CustomBaiaInformacoesTabCard extends StatefulWidget {
  @override
  _CustomBaiaInformacoesTabCardState createState() => _CustomBaiaInformacoesTabCardState();
}

class _CustomBaiaInformacoesTabCardState extends State<CustomBaiaInformacoesTabCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Aberta em: 16/11/2023',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 7), 
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Aberta por: Walter White',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 22), 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,    
                elevation: 5,    
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroAnimal');               
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Abrir Cadastro do animal',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Anotações',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: 
                Column(
                  children: [
                    CustomPreVisualizacaoAnotacaoCard(),                     
                    SizedBox(height: 15),
                    CustomPreVisualizacaoAnotacaoCard(),                     
                    SizedBox(height: 15),
                    CustomPreVisualizacaoAnotacaoCard(),                     
                    SizedBox(height: 15),
                  ],
                )
              ),
            ),
          ),
          //fim tab1
        ],
      ),
    );
  }
}