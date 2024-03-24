import 'package:flutter/material.dart';
import 'package:mobile/model/granja_model.dart';

class CustomGranjaRegistroCard extends StatelessWidget {
  final GranjaModel granja;
  final VoidCallback onEditarPressed;
  final VoidCallback onExcluirPressed;
  final String caminhoTelaAoClicar;

  const CustomGranjaRegistroCard({
    Key? key,
    required this.granja,
    required this.onEditarPressed,
    required this.onExcluirPressed,
    required this.caminhoTelaAoClicar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/${caminhoTelaAoClicar}');               
        }, 
        child: Card(
          color: Colors.white,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 10,  // Ajuste a largura da borda conforme necessário
                        color: Colors.orange,  // Cor da borda
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 16),  // Ajuste o recuo conforme necessário
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        granja.descricao,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.landscape, // Ícone de localização (substitua pelo ícone desejado)
                            color: Colors.red, // Cor do ícone (ajuste conforme necessário)
                          ),
                          SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                          Text(
                            'Fazenda - ${granja.fazenda?.nome}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: onEditarPressed,
                            icon: Icon(Icons.edit, color: Colors.white),
                            label: Text(
                              'Editar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 8), // Espaço entre os botões
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
                      )
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
