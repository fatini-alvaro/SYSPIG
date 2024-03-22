import 'package:flutter/material.dart';
import 'package:mobile/components/criar_conta/custom_possuo_conta_button_componente.dart';
import 'package:mobile/components/criar_conta/custom_salvar_nova_conta_button_component.dart';
import 'package:mobile/controller/criar_conta/criar_conta_controller.dart';
import 'package:mobile/utils/dialogs.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CriarContaPage extends StatefulWidget {
  @override
  _CriarContaPageState createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {

  final CriarContaController _criarContaController = CriarContaController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _body(){
    
     return SingleChildScrollView(
      child: SizedBox( 
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 20),   
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),          
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormFieldWidget(
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
                            onChanged: _criarContaController.setEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 25),
                          CustomTextFormFieldWidget(
                            validator: (value) {
                              // add email validation
                              if (value == null || value.isEmpty) {
                                return 'Nome obrigatório';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Insira o nome',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _criarContaController.setNome,
                          ),
                          SizedBox(height: 25),
                          CustomTextFormFieldWidget(
                            validator: (value) {
                              // add email validation
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
                            onChanged: _criarContaController.setSenha,
                          ),
                          SizedBox(height: 25),
                          CustomSalvarNovaContaButtonComponent(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _criarContaController
                                    .create(context)
                                    .then((resultado) {
                                    if (resultado) {
                                      Navigator.of(context)
                                          .pushNamed('/login');
                                    } else {
                                      Dialogs.errorToast(context,
                                          "Não foi possível criar o usuário.");
                                    }
                                });
                              }
                            },
                            criarContaController: _criarContaController,
                          ),
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 5,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(height: 10),
                          CustomPossuoContaButtonComponent()
                        ]
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(), 
    );  
  }
}