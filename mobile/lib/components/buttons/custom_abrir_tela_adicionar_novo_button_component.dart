import 'package:flutter/material.dart';

class CustomAbrirTelaAdicionarNovoButtonComponent extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;

  CustomAbrirTelaAdicionarNovoButtonComponent({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,    
        elevation: 5,    
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Ajuste o valor conforme necessário
        ),
      ),
      onPressed: onPressed, 
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