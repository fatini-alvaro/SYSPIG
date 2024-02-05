import 'package:flutter/material.dart';
import 'package:mobile/controller/login/login_controller.dart';
import 'package:mobile/controller/post/posts_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final PostsController _controller = PostsController();

  final LoginController _loginController = LoginController();

  Widget _body(){
     return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox( 
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Container(height: 20), 
                    AnimatedBuilder(
                      animation: Listenable.merge([_controller.posts, _controller.inLoader]),
                      builder: (_, __) => _controller.inLoader.value ? CircularProgressIndicator() : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _controller.posts.value.length,
                        itemBuilder: (_, idx) => ListTile(
                          title: Text(_controller.posts.value[idx].title),
                        ),
                      ),
                    ),
                    Container(height: 20),            
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 12),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: _loginController.setEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder()
                              ),
                            ),
                            SizedBox(height: 25),
                            TextField(
                              onChanged: _loginController.setSenha,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder()
                              ),
                            ),
                            SizedBox(height: 25),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange, // Change the background color
                                foregroundColor: Colors.white, // Change the text color
                              ),
                              onPressed: () {
                               // _loginController.auth();
                              }, 
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  'Entrar',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _controller.callAPI();
                              }, 
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  'Testar Api',
                                  textAlign: TextAlign.center
                                ),
                              )
                            )
                          ]
                        ),
                      ),
                    ),              
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(), 
    );  
  }
}

