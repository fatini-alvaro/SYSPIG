import 'package:flutter/material.dart';
import 'package:mobile/controller/criar_conta/criar_conta_controller.dart';

class CustomSalvarNovaContaButtonComponent extends StatelessWidget {
  final CriarContaController criarContaController;
  const CustomSalvarNovaContaButtonComponent({Key? key, required this.criarContaController,}) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange, // Change the background color
        foregroundColor: Colors.white,
        minimumSize: Size(MediaQuery.of(context).size.width, 50), // Change the text color
      ),
      onPressed: () async {
        bool created = await criarContaController.create(context);
        if (created) {
          // Lógica para lidar com a conta criada com sucesso
        } else {
          // Lógica para lidar com falha na criação da conta
          // Você pode querer exibir uma mensagem de erro ou fazer algo adequado aqui
        }
      },
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