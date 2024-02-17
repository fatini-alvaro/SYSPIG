// import 'package:flutter/material.dart';
// import 'package:mobile/controller/login/login_controller.dart';

// class CustomLoginButtonComponent extends StatelessWidget {
  
//   final LoginController loginController;
//   const CustomLoginButtonComponent({Key? key, required this.loginController,}) : super(key: key,);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.orange, // Change the background color
//         foregroundColor: Colors.white,
//         minimumSize: Size(MediaQuery.of(context).size.width, 50), // Change the text color
//       ),
//       onPressed: () {
//         loginController.auth(context).then(
//           (result) {
//           if(result) {
//             Navigator.of(context).pushNamed('/selecionarFazenda');
//           } else {
//             print('erro');
//           }                                
//         });
//       }, 
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Text(
//           'Entrar',
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mobile/controller/login/login_controller.dart';

class CustomLoginButtonComponent extends StatelessWidget {
  
  final LoginController loginController;
  final VoidCallback? onPressed; // Adiciona o VoidCallback onPressed

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
