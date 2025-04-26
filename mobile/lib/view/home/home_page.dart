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
import 'package:syspig/view/home/acoes_page.dart';
import 'package:syspig/view/home/dashboard_page.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    AcoesPage(), 
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawerWidget(
        accountName: _user?.nome ?? 'nome',
        accountEmail: _user?.email ?? 'email',
        onHomeTap: () => Logger().e('Home tapped'),
        onSelecionarFazendaTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/selecionarFazenda', (_) => true);
        },
        onLogoutTap: () {
          PrefsService.logout();
        },
      ),
      appBar: CustomAppBarWidget(
        titulo: Text(_fazenda?.nome ?? 'Fazenda'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 28,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Ações',
          ),
        ],
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