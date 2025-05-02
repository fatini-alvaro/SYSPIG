import 'package:flutter/material.dart';
import 'package:syspig/model/venda_model.dart';

class CustomVendaCard extends StatelessWidget {
  final VendaModel venda;

  const CustomVendaCard({
    Key? key,
    required this.venda,
  }) : super(key: key);

  String _formatarData(DateTime? data) {
    if (data == null) return '--/--/---- --:--';
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year} '
        '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Venda de Leitões',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Primeira linha com 2 itens
            Row(
              children: [
                _buildInfoItem(
                  Icons.calendar_today,
                  'Data da venda',
                  _formatarData(venda.datavenda),
                ),
                _buildInfoItem(
                  Icons.inventory,
                  'Quantidade',
                  '${venda.quantidadeVendida ?? '-'} leitões',
                ),
              ],
            ),
            
            // Segunda linha com 2 itens
            Row(
              children: [
                _buildInfoItem(
                  Icons.scale,
                  'Peso total',
                  '${venda.peso?.toStringAsFixed(2) ?? '-'} kg',
                ),
                _buildInfoItem(
                  Icons.attach_money,
                  'Valor total',
                  'R\$ ${venda.valorVenda?.toStringAsFixed(2) ?? '-'}',
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            
            // Rodapé
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Registrado por: ${venda.createdBy?.nome ?? 'Desconhecido'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  _formatarData(venda.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}