import 'package:flutter/material.dart';

class CustomPossuoContaButtonComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/login');
      }, 
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          'Possua uma Conta',
          textAlign: TextAlign.center
        ),
      )
    );
  }
}