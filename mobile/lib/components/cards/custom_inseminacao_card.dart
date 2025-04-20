import 'package:flutter/material.dart';
import 'package:syspig/model/inseminacao_model.dart';

class CustomInseminacaoCard extends StatelessWidget {
  final InseminacaoModel inseminacao;

  const CustomInseminacaoCard({
    Key? key,
    required this.inseminacao,
  }) : super(key: key);

  String _formatarData(DateTime? data) {
    if (data == null) return '--/--/---- --:--';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.purple.shade50, // cor opcional para diferenciar
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inseminação Lote - ${inseminacao.lote!.numeroLote ?? '--'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  _formatarData(inseminacao.data),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Fêmea
            Row(
              children: [
                const Icon(Icons.pets, size: 18, color: Colors.black54),
                const SizedBox(width: 4),
                const Text('Fêmea: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(inseminacao.porcaInseminada?.numeroBrinco ?? '--'),
              ],
            ),

            // Reprodutor
            Row(
              children: [
                const Icon(Icons.male, size: 18, color: Colors.black54),
                const SizedBox(width: 4),
                const Text('Porco: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(inseminacao.porcoDoador?.numeroBrinco ?? '--'),
              ],
            ),

            // Baia
          Row(
            children: [
              const Icon(Icons.home, size: 18, color: Colors.black54),
              const SizedBox(width: 4),
              const Text('Baia De Inseminação: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(inseminacao.baia?.numero ?? '--'),
            ],
          ),


            // Usuário
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.black54),
                const SizedBox(width: 4),
                const Text('Usuário: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(inseminacao.createdBy?.nome ?? '--'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
