import 'package:flutter/material.dart';
import 'package:syspig/enums/movimentacao_constants.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/themes/themes.dart';

class CustomMovimentacaoCard extends StatelessWidget {
  final MovimentacaoModel movimentacao;
  final VoidCallback? onEditarPressed;
  final VoidCallback? onExcluirPressed;

  const CustomMovimentacaoCard({
    Key? key,
    required this.movimentacao,
    this.onEditarPressed,
    this.onExcluirPressed,
  }) : super(key: key);

  String _formatarData(DateTime? data) {
    if (data == null) return '--/--/---- --:--';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  Color _getCardColor() {
    switch (movimentacao.tipo) {
      case TipoMovimentacao.entrada:
        return Colors.green.shade100;
      case TipoMovimentacao.transferencia:
        return Colors.blue.shade100;
      case TipoMovimentacao.saida:
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getIcon() {
    switch (movimentacao.tipo) {
      case TipoMovimentacao.entrada:
        return Icons.arrow_downward;
      case TipoMovimentacao.transferencia:
        return Icons.swap_horiz;
      case TipoMovimentacao.saida:
        return Icons.arrow_upward;
      default:
        return Icons.help_outline;
    }
  }

  String _getTipoDescricao() {
    return movimentacao.tipo?.description ?? 'Desconhecido';
  }

  String _getStatusDescricao() {
    return movimentacao.status?.description ?? 'Desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: _getCardColor(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_getIcon(), size: 24, color: Colors.black54),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTipoDescricao(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Status: ${_getStatusDescricao()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  _formatarData(movimentacao.dataMovimentacao),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (movimentacao.baiaOrigem != null || movimentacao.baiaDestino != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.black54),
                    const SizedBox(width: 4),
                    const Text('Origem: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(movimentacao.baiaOrigem?.numero ?? '--'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18, color: Colors.black54),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on, size: 18, color: Colors.black54),
                    const SizedBox(width: 4),
                    const Text('Destino: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(movimentacao.baiaDestino?.numero ?? '--'),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.pets, size: 18, color: Colors.black54),
                  const SizedBox(width: 4),
                  const Text('Animal: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(movimentacao.animal?.numeroBrinco ?? '--'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 18, color: Colors.black54),
                  const SizedBox(width: 4),
                  const Text('Usuário: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(movimentacao.usuario?.nome ?? '--'),
                ],
              ),
            ),
            if (movimentacao.observacoes != null && movimentacao.observacoes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes, size: 18, color: Colors.black54),
                    const SizedBox(height: 4),
                    const Text('Observações: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(movimentacao.observacoes!),
                  ],
                ),
              ),
            if (onEditarPressed != null || onExcluirPressed != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEditarPressed != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEditarPressed,
                    ),
                  if (onExcluirPressed != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onExcluirPressed,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}