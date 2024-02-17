// import 'package:flutter/material.dart';
// import 'package:mobile/controller/app_controller.dart';
// import 'package:mobile/controller/home/home_controller.dart';
// import 'package:mobile/model/post_model.dart';
// //import 'package:mobile/repositories/home_repository_imp.dart';
// import 'package:mobile/widgets/custom_drawer_widget.dart';

// class HomePage extends StatefulWidget{
//   @override
//   State<HomePage> createState() {
//     return HomePageState();
//   }
// }

// class HomePageState extends State<HomePage> {

//   final HomeController _homeController = HomeController(HomeRepositoryImp());

//   @override
//   void initState() {
//     super.initState();
//     _homeController.fetch();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: Text('SYSPIG'),
//       ),      
//       body: ValueListenableBuilder<List<PostModel>>(
//         valueListenable: _homeController.posts, 
//         builder: (_, list, __){
//           return ListView.separated(
//             shrinkWrap: true,
//             itemCount: list.length,
//             itemBuilder: (_, idx) => ListTile(
//               leading: Text(list[idx].id.toString()),
//               trailing: Icon(Icons.arrow_forward),
//               title: Text(list[idx].title),
//               onTap: () => Navigator.of(context).pushNamed(
//                 '/details', 
//                 arguments: list[idx],
//               ),
//             ),
//             separatorBuilder: (_, __) => Divider(),
//           );
//         }
//       ),
//     );
//   }
// }

// class CustomSwitch extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Switch(
//       value: AppController.instance.isDarkTheme,
//       onChanged: (value) {
//         AppController.instance.changeTheme();
//       },
//     );
//   }
// }