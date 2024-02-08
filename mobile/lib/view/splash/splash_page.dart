import 'package:flutter/material.dart';
import 'package:mobile/services/prefs_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  void initState() {
    super.initState();

    Future.wait([
      PrefsService.isAuth(),
      Future.delayed(Duration(seconds: 2)),
    ]).then((value) => value[0] 
        ? Navigator.of(context).pushReplacementNamed('/home') 
        : Navigator.of(context).pushReplacementNamed('/login'));

    // Future.delayed(Duration(seconds: 3)).then(
    //   (_) => Navigator.of(context).pushReplacementNamed('/login'),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
        children: [
          Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/images/logoWhite.png'),
          ),
          Container(height: 20), 
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}