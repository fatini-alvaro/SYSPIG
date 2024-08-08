import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_pre_visualizacao_anotacao_card.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/utils/date_format_util.dart';
import 'package:syspig/view/animal/cadastrar_animal_page.dart';

class CustomBaiaInformacoesTabCard extends StatefulWidget {

  final OcupacaoModel? ocupacao;

  CustomBaiaInformacoesTabCard({Key? key, this.ocupacao}) : super(key: key);

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
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Aberta em: ${widget.ocupacao?.dataAbertura != null ? DateFormatUtil.defaultFormat.format(widget.ocupacao!.dataAbertura!) : "Data não disponível"}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7), 
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Aberta por: ${widget.ocupacao?.createdBy != null ? widget.ocupacao!.createdBy!.nome : "Informção não disponivel"}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7), 
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Animal: ${widget.ocupacao!.animal!.numeroBrinco}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22), 
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastrarAnimalPage(
                      animalParaEditar: widget.ocupacao!.animal!,
                    ),
                  )
                );
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