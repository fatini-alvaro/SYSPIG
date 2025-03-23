import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_pre_visualizacao_anotacao_card.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/utils/date_format_util.dart';
import 'package:syspig/view/animal/cadastrar_animal_page.dart';
import 'package:syspig/widgets/custom_data_table.dart';

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
      child: ListView(
        shrinkWrap: true, // Faz com que o ListView ocupe apenas o espaço necessário
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
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(16),
            child: CustomDataTable(
              title: 'Animais na baia',
              columns: const [
                DataColumn(
                  label: Text(
                    'Nº Brinco',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sexo',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              data: widget.ocupacao?.ocupacaoAnimais ?? [],
              generateRows: (animais) {
                return animais.map((ocupacaoAnimal) {
                  return DataRow(
                    cells: [
                      DataCell(Text(ocupacaoAnimal.animal!.numeroBrinco)),
                      DataCell(Text(ocupacaoAnimal.animal!.sexo == SexoAnimal.macho ? 'Macho' : 'Fêmea')),
                    ],
                  );
                }).toList();
              },
            ),
          ),
         SizedBox(height: 15),
          Center( // Centraliza o texto horizontalmente
            child: Text(
              'Anotações',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.ocupacao?.anotacoes != null && widget.ocupacao!.anotacoes!.isNotEmpty)
                  ...widget.ocupacao!.anotacoes!.map((anotacao) => CustomPreVisualizacaoAnotacaoCard(anotacao: anotacao)).toList()
                else
                  Text("Nenhuma anotação disponível"),
              ],
            ),
          ),          // Fim tab1
        ],
      ),
    );
  }
}
