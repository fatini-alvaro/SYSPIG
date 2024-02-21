import 'package:flutter/material.dart';

class CustomDrawerWidget extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final Function() onHomeTap;
  final Function() onLogoutTap;
  final Function() onSelecionarFazendaTap;

  CustomDrawerWidget({
    required this.accountName,
    required this.accountEmail,
    required this.onHomeTap,
    required this.onLogoutTap,
    required this.onSelecionarFazendaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset('assets/images/logoBlack.png'),
            ),
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            subtitle: Text('Tela de Inicio'),
            onTap: onHomeTap,
          ),
          ListTile(
            leading: Icon(Icons.landscape),
            title: Text('Trocar Fazenda'),
            subtitle: Text('Selecionar outra fazenda'),
            onTap: onSelecionarFazendaTap,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            subtitle: Text('Sair do seu usuário'),
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}
