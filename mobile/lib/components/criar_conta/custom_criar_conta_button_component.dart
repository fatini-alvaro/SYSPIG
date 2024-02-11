import 'package:flutter/material.dart';

class CustomCriarContaButtonComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/criarConta');               
      }, 
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          'Criar conta',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}