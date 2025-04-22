import 'package:flutter/material.dart';
import 'package:syspig/components/cards/custom_pre_visualizacao_anotacao_card.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/utils/date_format_util.dart';
import 'package:syspig/utils/gestacao_util.dart';
import 'package:syspig/view/animal/cadastrar_animal_page.dart';
import 'package:syspig/widgets/custom_data_table.dart';

class CustomBaiaInformacoesTabCard extends StatefulWidget {

  final OcupacaoModel? ocupacao;
  final BaiaModel? baia;

  CustomBaiaInformacoesTabCard({Key? key, this.ocupacao, this.baia}) : super(key: key);

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
          _buildInfoSection(),
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
              data: widget.ocupacao?.ocupacaoAnimaisSemNascimento ?? [],
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

  Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final dataAbertura = widget.ocupacao?.dataAbertura != null
        ? DateFormatUtil.defaultFormat.format(widget.ocupacao!.dataAbertura!)
        : "Data não disponível";
    final abertaPor = widget.ocupacao?.createdBy?.nome ?? "Informação não disponível";

    final ocupacoesSemNascimento = widget.ocupacao?.ocupacaoAnimaisSemNascimento ?? [];
    final animalComInseminacao = ocupacoesSemNascimento.isNotEmpty
        ? ocupacoesSemNascimento.first.animal
        : null;
    final dataInseminacao = animalComInseminacao?.dataUltimaInseminacao;

    final infoGestacao = dataInseminacao != null
        ? GestacaoUtil.calcularInfoGestacao(dataInseminacao)
        : null;

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Informações da Ocupação", style: Theme.of(context).textTheme.titleMedium),
            const Divider(),

            _buildInfoItem(icon: Icons.calendar_today, label: "Aberta em", value: dataAbertura),
            _buildInfoItem(icon: Icons.person, label: "Aberta por", value: abertaPor),

            if ((widget.baia!.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.inseminacao] ||
                widget.baia!.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.gestacao]) &&
                dataInseminacao != null &&
                infoGestacao != null) ...[
              const SizedBox(height: 10),
              _buildInfoItem(
                icon: Icons.pets,
                label: "Inseminação",
                value: "${DateFormatUtil.defaultFormat.format(dataInseminacao)} "
                    "(${infoGestacao.diasDesdeInseminacao} dias atrás)",
              ),
              _buildInfoItem(
                icon: Icons.child_care,
                label: "Previsão de parto",
                value: "${infoGestacao.dataPrevistaParto.day.toString().padLeft(2, '0')}/"
                        "${infoGestacao.dataPrevistaParto.month.toString().padLeft(2, '0')}/"
                        "${infoGestacao.dataPrevistaParto.year}",
              ),
              _buildInfoItem(
                icon: Icons.cake,
                label: "Qtd. de nascimentos",
                value: widget.ocupacao!.ocupacaoAnimaisNascimento.length.toString(),
              ),
            ]
          ],
        ),
      ),
    );
  }

}
