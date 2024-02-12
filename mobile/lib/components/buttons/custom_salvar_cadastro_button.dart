import 'package:flutter/material.dart';

class CustomSalvarCadastroButtonComponent extends StatelessWidget {
  final String buttonText;
  final String caminhoTelaCadastro;

  CustomAbrirTelaAdicionarNovoButtonComponent({required this.buttonText, required this.caminhoTelaCadastro});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,        
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Ajuste o valor conforme necessário
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/${caminhoTelaCadastro}');               
      }, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(width: 8), // Add some space between icon and text
          Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}