import 'package:flutter/material.dart';
import 'package:mobile/components/criar_conta/custom_criar_conta_button_component.dart';
import 'package:mobile/components/login/custom_login_button_component.dart';
import 'package:mobile/controller/login/login_controller.dart';
import 'package:mobile/utils/dialogs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = LoginController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Container(height: 20),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              // add email validation
                              if (value == null || value.isEmpty) {
                                return 'Email obrigatório';
                              }

                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (!emailValid) {
                                return 'Email inválido';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Insira o email',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _loginController.setEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Senha obrigatória';
                              }

                              if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Insira a senha',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _loginController.setSenha,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              // Lógica para "Esqueci a senha"
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Esqueci a senha',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 243, 163,
                                      33), // Defina a cor desejada aqui
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          CustomLoginButtonComponent(
                            loginController: _loginController,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _loginController
                                    .autenticarUsuario()
                                    .then((resultado) {
                                  if (resultado) {
                                    Navigator.of(context)
                                        .pushNamed('/selecionarFazenda');
                                  } else {
                                    Dialogs.errorToast(context,
                                        "Credenciais inválidas.Tente novamente.");
                                  }
                                });
                              }
                            },
                          ),
                          SizedBox(height: 55),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 10,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(height: 45),
                          CustomCriarContaButtonComponent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}