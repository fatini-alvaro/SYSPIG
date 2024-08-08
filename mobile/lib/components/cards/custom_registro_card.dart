import 'package:flutter/material.dart';

class CustomRegistroCard extends StatelessWidget {
  final VoidCallback onEditarPressed;
  final VoidCallback onExcluirPressed;
  final Function()? onTap;
  final Widget descricao;

  const CustomRegistroCard({
    Key? key,
    required this.onEditarPressed,
    required this.onExcluirPressed,
    this.onTap,
    required this.descricao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap:onTap,
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
                      descricao,
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
