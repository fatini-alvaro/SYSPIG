import 'package:flutter/material.dart';
import 'package:mobile/controller/app_controller.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/view/animal/cadastrar_animal_page.dart';
import 'package:mobile/view/anotacao/cadastrar_anotacao_page.dart';
import 'package:mobile/view/baia/baia_gestacao_page.dart';
import 'package:mobile/view/baia/baia_page.dart';
import 'package:mobile/view/baia/cadastrar_baia_page.dart';
import 'package:mobile/view/baiasGestacaoOcupadas/baias_gestacao_ocupadas_page.dart';
import 'package:mobile/view/criar_conta/criar_conta_page.dart';
import 'package:mobile/view/details_page/details_page.dart';
import 'package:mobile/view/fazenda/cadastrar_fazenda_page.dart';
import 'package:mobile/view/granja/cadastrar_granja_page.dart';
import 'package:mobile/view/inseminacao/cadastrar_inseminacao_page.dart';
import 'package:mobile/view/login/login_page.dart';
import 'package:mobile/view/lote/cadastrar_lote_page.dart';
import 'package:mobile/view/movimentacao/cadastrar_movimentacao_page.dart';
import 'package:mobile/view/selecionar_animal/selecionar_animal_page.dart';
import 'package:mobile/view/selecionar_anotacao/selecionar_anotacao_page.dart';
import 'package:mobile/view/selecionar_baia/selecionar_baia_page.dart';
import 'package:mobile/view/selecionar_fazenda/selecionar_fazenda_page.dart';
import 'package:mobile/view/selecionar_granja/selecionar_granja_page.dart';
import 'package:mobile/view/selecionar_inseminacao/selecionar_inseminacao_page.dart';
import 'package:mobile/view/selecionar_lote/selecionar_lote_page.dart';
import 'package:mobile/view/selecionar_movimentacao/selecionar_movimentacao_page.dart';
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
          //EXEMPLO
          '/details': (context) => const DetailsPage(),
          //conta
          '/criarConta': (context) => CriarContaPage(),
          //fazenda
          '/selecionarFazenda': (context) => SelecionarFazendaPage(),
          '/abrirTelaCadastroFazenda': (context) => CadastrarFazendaPage(),
          //granja
          '/selecionarGranja': (context) => SelecionarGranjaPage(),
          '/abrirTelaCadastroGranja': (context) => CadastrarGranjaPage(),
          //animal
          '/selecionarAnimal': (context) => SelecionarAnimalPage(),
          '/abrirTelaCadastroAnimal': (context) => CadastrarAnimalPage(),
          //anotacao
          '/selecionarAnotacao': (context) => SelecionarAnotacaoPage(),
          '/abrirTelaCadastroAnotacao': (context) => CadastrarAnotacaoPage(),
          //baia
          '/selecionarBaia': (context) => SelecionarBaiaPage(),
          '/abrirTelaCadastroBaia': (context) => CadastrarBaiaPage(),
          '/baia': (context) => BaiaPage(),
          '/baiasGestacaoOcupadas': (context) => BaiasGestacaoOcupadasPage(),
          '/baiaGestacao': (context) => BaiaGestacaoPage(),
          //Movimentação
          '/selecionarMovimentacao': (context) => SelecionarMovimentacaoPage(),
          '/abrirTelaCadastroMovimentacao': (context) => CadastrarMovimentacaoPage(),
          //lote
          '/selecionarLote': (context) => SelecionarLotePage(),
          '/abrirTelaCadastroLote': (context) => CadastrarLotePage(),
          //Inseminacao
          '/selecionarInseminacao': (context) => SelecionarInseminacaoPage(),
          '/abrirTelaCadastroInseminacao': (context) => CadastrarInseminacaoPage(),
        },
      );  
    });
  }
} 