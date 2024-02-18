import 'package:flutter/material.dart';
import 'package:mobile/components/cards/custom_home_card.dart';
import 'package:mobile/controller/app_controller.dart';
import 'package:mobile/controller/home/home_controller.dart';
import 'package:mobile/repositories/home/home_repository_imp.dart';
import 'package:mobile/services/prefs_service.dart';
import 'package:mobile/widgets/custom_appbar_widget.dart';
import 'package:mobile/widgets/custom_drawer_widget.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  final HomeController _homeController = HomeController(HomeRepositoryImp());

  @override
  void initState() {
    super.initState();
    _homeController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawerWidget(
        accountName: 'Alvaro',
        accountEmail: 'alvarofatini@gmail.com',
        onHomeTap: () {
          print('Home tapped');
        },
        onSelecionarFazendaTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/selecionarFazenda', (_) => true);
        },
        onLogoutTap: () {
          PrefsService.logout();
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => true);
        },
      ),
      appBar: CustomAppBarWidget(titulo: Text('Fazenda Alvaro')),      
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                CustomHomeCard(
                  descricao: 'Gestação',
                  icone: Icons.child_friendly,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/baiasGestacaoOcupadas');
                  },
                ),
                SizedBox(height: 20),
                CustomHomeCard(
                  descricao: 'Movimentação',
                  icone: Icons.compare_arrows,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarMovimentacao');
                  },
                ),
              ]
            ),
            Row(
              children: [
                CustomHomeCard(
                  descricao: 'Granjas',
                  icone: Icons.house_siding,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarGranja');
                  },
                ),
                SizedBox(height: 20),
                CustomHomeCard(
                  descricao: 'Animais',
                  icone: Icons.pets,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarAnimal');
                  },
                ),
              ]
            ),
            Row(
              children: [
                CustomHomeCard(
                  descricao: 'lotes',
                  icone: Icons.abc,
                  onTapCallback: () {
                    // 
                  },
                ),
                SizedBox(height: 20),
                CustomHomeCard(
                  descricao: 'Anotações',
                  icone: Icons.note_alt_outlined,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarAnotacao');
                  },
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDarkTheme,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}