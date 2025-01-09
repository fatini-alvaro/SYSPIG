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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      height: 50,
      child: GestureDetector(
        onTap: baia.vazia! ? onTapVazia : onTapOcupada,
        child: Card(
          color: baia.vazia! ? Colors.grey : Colors.orange,
          elevation: 7,
          child: Container(
            width: 170,
            height: 170,
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 10,
                  child: Container(
                    width: 150, // Ajuste este valor conforme necessário
                    height: 40,
                    child: Text(
                        'Nº - ${baia.numero}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                    ),                    
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 10,
                  child: Container(
                    width: 150, // Ajuste este valor conforme necessário
                    height: 40,
                    child: Text(
                        'Granja - ${baia.granja?.descricao}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                    ),                    
                  ),
                ),
                if (!baia.vazia!) 
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Brinco:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "- ${baia.ocupacao?.animal!.numeroBrinco}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                 if (baia.vazia!)  
                  const Positioned(
                    bottom: 50,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vazia",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Clique para abrir",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
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
