import 'package:flutter/material.dart';

class CustomFazendaRegistroCard extends StatelessWidget {
  final String fazendaNome;
  final VoidCallback onEditarPressed;
  final VoidCallback onExcluirPressed;

  const CustomFazendaRegistroCard({
    Key? key,
    required this.fazendaNome,
    required this.onEditarPressed,
    required this.onExcluirPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fazendaNome,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: onEditarPressed,
                  icon: Icon(Icons.edit, color: Colors.white), // Ícone de edição
                  label: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor de fundo azul (pode ajustar conforme necessário)
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onExcluirPressed,
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    'Excluir',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
