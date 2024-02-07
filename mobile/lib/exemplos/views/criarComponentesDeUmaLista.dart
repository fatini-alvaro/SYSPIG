import 'package:flutter/material.dart';
import 'package:mobile/controller/app_controller.dart';
import 'package:mobile/controller/home/home_controller.dart';
import 'package:mobile/model/post_model.dart';
import 'package:mobile/repositories/home_repository.dart';
import 'package:mobile/repositories/home_repository_mock.dart';
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
      drawer: CustomDrawerWidget(
        accountName: 'Alvaro',
        accountEmail: 'alvarofatini@gmail.com',
        onHomeTap: () {
          print('Home tapped');
        },
        onLogoutTap: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('SYSPIG'),
      ),      
      body: ValueListenableBuilder<List<PostModel>>(
        valueListenable: _homeController.posts, 
        builder: (_, list, __){//aqui da pra passar um widget 
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, idx) => ListTile(
              title: Text(list[idx].title),
            )
          );
        }
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