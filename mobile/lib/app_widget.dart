import 'package:flutter/material.dart';
import 'package:mobile/controller/app_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/view/criar_conta/criar_conta_page.dart';
import 'package:mobile/view/details_page/details_page.dart';
import 'package:mobile/view/login/login_page.dart';
import 'package:mobile/view/selecionar_fazenda/selecionar_fazenda_page.dart';
import 'package:mobile/view/splash/splash_page.dart';

import 'view/home/home_page.dart';

class AppWidget extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
      return MaterialApp(
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: AppController.instance.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/details': (context) => const DetailsPage(),
          '/criarConta': (context) => CriarContaPage(),
          '/selecionarFazenda': (context) => SelecionarFazendaPage(),
        },
      );  
    });
  }
} 