
import 'package:flutter/material.dart';
import 'package:syspig/controller/login/login_controller.dart';

class CustomLoginButtonComponent extends StatelessWidget {
  
  final LoginController loginController;
  final VoidCallback? onPressed;

   // Atualiza o construtor para aceitar o onPressed
  const CustomLoginButtonComponent({Key? key, required this.loginController, this.onPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      onPressed: onPressed, // Usa o onPressed passado como parâmetro
      child: Container(width: MediaQuery.of(context).size.width,
      child: Text('Entrar',textAlign: TextAlign.center)),
    );
  }
}