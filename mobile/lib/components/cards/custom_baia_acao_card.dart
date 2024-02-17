import 'package:flutter/material.dart';

class CustomBaiaAcaoCard extends StatelessWidget {
  final String descricao;
  final IconData icone;
  final VoidCallback onTapCallback;

  const CustomBaiaAcaoCard({
    Key? key,
    required this.descricao,
    required this.icone,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTapCallback,
        child: Card(
          color: Colors.orange,
          elevation: 5,
          child: Container(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icone,
                  size: 64, // Tamanho do ícone, ajuste conforme necessário
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  descricao,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
