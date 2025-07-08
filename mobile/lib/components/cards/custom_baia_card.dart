import 'package:flutter/material.dart';
import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/utils/gestacao_util.dart';

class CustomBaiaCard extends StatelessWidget {
  final BaiaModel baia;
  final VoidCallback onTapOcupada;
  final VoidCallback onTapVazia;

  const CustomBaiaCard({
    Key? key,
    required this.baia,
    required this.onTapOcupada,
    required this.onTapVazia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4; // 40% da tela
    double cardHeight = 160; // Altura fixa

    final animaisSemNascimento = baia.ocupacao?.ocupacaoAnimaisSemNascimento;

    final dataInseminacao = (animaisSemNascimento != null && animaisSemNascimento.isNotEmpty)
        ? animaisSemNascimento[0].animal?.dataUltimaInseminacao
        : null;

    GestacaoInfo? infoGestacao;
    if (dataInseminacao != null) {
      infoGestacao = GestacaoUtil.calcularInfoGestacao(dataInseminacao);
    } 

    return GestureDetector(
      onTap: () {
        if (baia.vazia!) {
          if (baia.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.geral]){
            onTapVazia();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Não é possivel abrir essa baia por aqui.')),
            );
            return;
          }
        } else {
          onTapOcupada();
        }
      },
      child: SizedBox(
        width: cardWidth,
        child: Card(
          color: _getBaiaColor(infoGestacao),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nº - ${baia.numero}',
                  maxLines: 2, // Limita a uma linha
                  overflow: TextOverflow.ellipsis, // Adiciona "..." se o texto for longo
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),  
                if (!baia.vazia! && infoGestacao != null && (baia.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.inseminacao] || baia.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.gestacao]))...[
                  Text(
                    'Inseminado há: ${infoGestacao!.diasDesdeInseminacao} dias',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Parto em: ${infoGestacao.dataPrevistaParto.day.toString().padLeft(2, '0')}/'
                    '${infoGestacao.dataPrevistaParto.month.toString().padLeft(2, '0')}/'
                    '${infoGestacao.dataPrevistaParto.year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (!baia.vazia!)
                  Text(
                    'Ocupação - ${baia.ocupacao?.codigo ?? "N/A"}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                if (baia.vazia!)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vazia",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (baia.vazia! && baia.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.geral])
                      const Text(
                        "Clique para abrir",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBaiaColor(infoGestacao) {
    if (baia.vazia!) return Colors.grey;

    if (infoGestacao != null && (baia.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.inseminacao] ||
        baia.granja!.tipoGranja!.id == tipoGranjaIdToInt[TipoGranjaId.gestacao])) {
      final dataInseminacao = baia.ocupacao?.ocupacaoAnimaisSemNascimento?[0].animal?.dataUltimaInseminacao;
      if (dataInseminacao != null) {
        final info = GestacaoUtil.calcularInfoGestacao(dataInseminacao);
        return info.corStatus;
      }
    }

    return Colors.orange;
  }

}
