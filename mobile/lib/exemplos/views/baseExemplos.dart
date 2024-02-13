import 'package:flutter/material.dart';
import 'package:mobile/controller/app_controller.dart';
import 'package:mobile/controller/home/home_controller.dart';
import 'package:mobile/repositories/home/home_repository_mock.dart';
import 'package:mobile/widgets/custom_drawer_widget.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  final HomeController _homeController = HomeController(HomeRepositoryMock());

  @override
  void initState() {
    super.initState();
    _homeController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: CustomDrawerWidget(
      //   accountName: 'Alvaro',
      //   accountEmail: 'alvarofatini@gmail.com',
      //   onHomeTap: () {
      //     print('Home tapped');
      //   },
      //   onLogoutTap: () {
      //     Navigator.of(context).pushReplacementNamed('/login');
      //   },
      // ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('SYSPIG'),
      ),      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black
                )
              ],
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