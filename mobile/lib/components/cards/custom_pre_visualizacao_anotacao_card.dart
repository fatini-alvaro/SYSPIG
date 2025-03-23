import 'package:flutter/material.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/utils/date_format_util.dart';

class CustomPreVisualizacaoAnotacaoCard extends StatelessWidget {
  final AnotacaoModel anotacao;

  CustomPreVisualizacaoAnotacaoCard({required this.anotacao});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do Criador
            Text(
              anotacao.createdBy?.nome != null
                  ? 'Criada por: ${anotacao.createdBy?.nome}'
                  : "Usuário desconhecido",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),

            // Data da anotação
            Text(
              anotacao.data != null
                  ? DateFormatUtil.defaultFormat.format(anotacao.data!)
                  : "Data não disponível",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),

            // Descrição
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                anotacao.descricao ?? 'Sem descrição',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
