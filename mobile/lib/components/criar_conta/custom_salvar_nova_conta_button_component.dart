import 'package:flutter/material.dart';
import 'package:mobile/controller/criar_conta/criar_conta_controller.dart';

class CustomSalvarNovaContaButtonComponent extends StatelessWidget {
  final CriarContaController criarContaController;
  final VoidCallback? onPressed;

  const CustomSalvarNovaContaButtonComponent({Key? key, required this.criarContaController, this.onPressed}) : super(key: key,);
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      onPressed: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          'Criar Conta',
          textAlign: TextAlign.center
        ),
      )
    );
  }
}