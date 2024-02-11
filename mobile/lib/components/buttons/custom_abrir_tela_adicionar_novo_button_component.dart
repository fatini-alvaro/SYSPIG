import 'package:flutter/material.dart';

class CustomAbrirTelaAdicionarNovoButtonComponent extends StatelessWidget {
  final String buttonText;

  CustomAbrirTelaAdicionarNovoButtonComponent({required this.buttonText});

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
        Navigator.of(context).pushReplacementNamed('/criarConta');               
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