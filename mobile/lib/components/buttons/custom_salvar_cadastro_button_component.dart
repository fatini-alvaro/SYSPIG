// import 'package:flutter/material.dart';

// class CustomSalvarCadastroButtonComponent extends StatelessWidget {
//   final String buttonText;
//   final String rotaTelaAposSalvar;

//   CustomSalvarCadastroButtonComponent({required this.buttonText, required this.rotaTelaAposSalvar});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,        
//         minimumSize: Size(MediaQuery.of(context).size.width, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5), // Ajuste o valor conforme necessário
//         ),
//       ),
//       onPressed: () {
//         Navigator.of(context).pushReplacementNamed('/${rotaTelaAposSalvar}');              
//       }, 
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.add,
//             color: Colors.white,
//           ),
//           SizedBox(width: 8), // Add some space between icon and text
//           Text(
//             buttonText,
//             style: TextStyle(color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Alterado para receber um onPressed pois foi alterado para formulário. 
import 'package:flutter/material.dart';

class CustomSalvarCadastroButtonComponent extends StatelessWidget {
  final String buttonText;
  final String rotaTelaAposSalvar;
  final VoidCallback? onPressed; // Adicione o parâmetro de função onPressed

  CustomSalvarCadastroButtonComponent({
    required this.buttonText,
    required this.rotaTelaAposSalvar,
    this.onPressed, // Atualize o construtor para incluir onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        minimumSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onPressed, // Use onPressed fornecido no construtor
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}