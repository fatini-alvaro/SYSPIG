// import 'package:flutter/material.dart';
// import 'package:syspig/components/login/custom_login_button_component.dart';
// import 'package:syspig/controller/login/login_controller.dart';
// import 'package:syspig/controller/post/posts_controller.dart';
// import 'package:syspig/widgets/custom_text_field_widget.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   final PostsController _postController = PostsController();

//   final LoginController _loginController = LoginController();

//   Widget _body(){
//      return SingleChildScrollView(
//       child: SizedBox( 
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(height: 20),   
//                 Container(
//                   width: 200,
//                   height: 200,
//                   child: Image.asset('assets/images/logo.png'),
//                 ),
//                 AnimatedBuilder(
//                   animation: Listenable.merge([_postController.posts, _postController.inLoader]),
//                   builder: (_, __) => _postController.inLoader.value ? CircularProgressIndicator() : ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: _postController.posts.value.length,
//                     itemBuilder: (_, idx) => ListTile(
//                       title: Text(_postController.posts.value[idx].title),
//                     ),
//                   ),
//                 ),
//                 Container(height: 20),            
//                 Card(
//                   elevation: 0,
//                   color: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 12),
//                     child: Column(
//                       children: [
//                         CustomTextFormFieldWidget(
//                           label: 'Insira o email', 
//                           onChanged: _loginController.setEmail, 
//                           keyboardType: TextInputType.emailAddress
//                         ),
//                         SizedBox(height: 25),
//                         CustomTextFormFieldWidget(
//                           label: 'Insira a senha', 
//                           onChanged: _loginController.setSenha,
//                           obscureText: true,
//                         ),
//                         SizedBox(height: 25),
//                         CustomLoginButtonComponent(
//                           loginController: _loginController,
//                         ),
//                         SizedBox(height: 10),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             foregroundColor: Colors.white,
//                             minimumSize: Size(MediaQuery.of(context).size.width, 50),
//                           ),
//                           onPressed: () {
//                             _postController.callAPI();
//                           }, 
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             child: Text(
//                               'Esqueci a senha',
//                               textAlign: TextAlign.center
//                             ),
//                           )
//                         ),
//                         SizedBox(height: 70),
//                         Divider(
//                           color: Colors.grey,
//                           thickness: 1,
//                           height: 10,
//                           indent: 20,
//                           endIndent: 20,
//                         ),
//                         SizedBox(height: 50),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.orange,
                            
//                             minimumSize: Size(MediaQuery.of(context).size.width, 50),
//                           ),
//                           onPressed: () {
//                             _postController.callAPI();
//                           }, 
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             child: Text(
//                               'Criar conta',
//                               textAlign: TextAlign.center
//                             ),
//                           )
//                         ),
//                       ]
//                     ),
//                   ),
//                 ),              
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _body(), 
//     );  
//   }
// }

