import 'package:flutter/material.dart';
import 'package:syspig/model/baia_model.dart';

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
    double cardHeight = 130; // Altura fixa

    return GestureDetector(
      onTap: baia.vazia! ? onTapVazia : onTapOcupada,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          color: baia.vazia! ? Colors.grey : Colors.orange,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),                
                if (!baia.vazia!)
                  Text(
                    'Ocupação - ${baia.ocupacao?.codigo ?? "N/A"}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                if (baia.vazia!)
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vazia",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
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
}
