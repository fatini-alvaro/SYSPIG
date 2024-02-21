import 'package:flutter/material.dart';
import 'package:mobile/model/fazenda_model.dart';

class CustomFazendaRegistroCard extends StatelessWidget {
  final FazendaModel fazenda;
  final VoidCallback onEditarPressed;
  final VoidCallback onExcluirPressed;
  final String caminhoTelaAoClicar;

  const CustomFazendaRegistroCard({
    Key? key,
    required this.fazenda,
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
                        fazenda.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on, // Ícone de localização (substitua pelo ícone desejado)
                            color: Colors.red, // Cor do ícone (ajuste conforme necessário)
                          ),
                          SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                          Text(
                            '${fazenda.cidade.nome} - ${fazenda.cidade.uf.sigla}',
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
