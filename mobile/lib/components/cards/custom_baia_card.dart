import 'package:flutter/material.dart';

class CustomBaiaCard extends StatelessWidget {
  final String numeroBaia;
  final String numeroBrincoBaia;
  final String statusBaia;
  final VoidCallback onTapCallback;

  const CustomBaiaCard({
    Key? key,
    required this.numeroBaia,
    required this.numeroBrincoBaia,
    required this.statusBaia,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: GestureDetector(
        onTap: onTapCallback,
        child: Card(
          color: Colors.orange,
          elevation: 7,
          child: Container(
            width: 170,
            height: 170,
            child: Stack(
              children: [
                // Positioned(
                //   top: 10,
                //   left: 10,
                //   child: Container(
                //     width: 150, // Ajuste este valor conforme necessário
                //     height: 40,
                //     child: Center(
                //       child: Text(
                //         'Baia Numero:',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 10,
                //   left: 10,
                //   child: Container(
                //     width: 150, // Ajuste este valor conforme necessário
                //     height: 40,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50),
                //       color: Colors.white,
                //     ),
                //     child: Center(
                //       child: Text(
                //         numeroBaia,
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: Container(
                    width: 150, // Ajuste este valor conforme necessário
                    height: 40,
                    child: Text(
                        numeroBaia,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                    ),                    
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Brincos:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "- ${numeroBrincoBaia}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
