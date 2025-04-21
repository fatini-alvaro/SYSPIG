import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:syspig/components/cards/custom_home_card.dart';
import 'package:syspig/controller/app_controller.dart';
import 'package:syspig/controller/home/home_controller.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/usuario_model.dart';
import 'package:syspig/repositories/home/home_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/widgets/custom_appbar_widget.dart';
import 'package:syspig/widgets/custom_drawer_widget.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  UsuarioModel? _user;
  FazendaModel? _fazenda;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    UsuarioModel? user = await PrefsService.getUser();
    if (user != null) {
      setState(() {
        _user = user;
      });
    }

    FazendaModel? fazenda = await PrefsService.getFazenda();
    if (fazenda != null) {
      setState(() {
        _fazenda = fazenda;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawerWidget(
        accountName: _user != null ? _user!.nome : 'nome',
        accountEmail: _user != null ? _user!.email : 'email',
        onHomeTap: () {
          Logger().e('Home tapped');
        },
        onSelecionarFazendaTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/selecionarFazenda', (_) => true);
        },
        onLogoutTap: () {
          PrefsService.logout();
        },
      ),
      appBar: CustomAppBarWidget(titulo: Text(_fazenda != null ? _fazenda!.nome : 'Fazenda')),      
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomHomeCard(
                  descricao: 'Baias',
                  icone: Icons.panorama_horizontal_select_outlined,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarBaia');
                  },
                ),   
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                SizedBox(height: 20),
                CustomHomeCard(
                  descricao: 'Granjas',
                  icone: Icons.house_siding,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarGranja');
                  },
                ),
                CustomHomeCard(
                  descricao: 'Animais',
                  icone: FontAwesomeIcons.piggyBank,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarAnimal');
                  },
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomHomeCard(
                  descricao: 'Anotações',
                  icone: Icons.note_alt_outlined,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarAnotacao');
                  },
                ),
                SizedBox(height: 20),
                CustomHomeCard(
                  descricao: 'lotes',
                  icone: Icons.note,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarLote');
                  },
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                CustomHomeCard(
                  descricao: 'Inseminação',
                  icone: Icons.vaccines,
                  onTapCallback: () {
                    Navigator.of(context).pushNamed('/selecionarInseminacao');
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