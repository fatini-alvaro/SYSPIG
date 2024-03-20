import 'package:flutter/material.dart';
import 'package:mobile/components/criar_conta/custom_possuo_conta_button_componente.dart';
import 'package:mobile/components/criar_conta/custom_salvar_nova_conta_button_component.dart';
import 'package:mobile/controller/criar_conta/criar_conta_controller.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CriarContaPage extends StatefulWidget {
  @override
  _CriarContaPageState createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {

  final CriarContaController _criarContaController = CriarContaController();

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
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 12),
                    child: Column(
                      children: [
                        CustomTextFormFieldWidget(
                          label: 'Insira o email', 
                          onChanged: (value) {
                            _criarContaController.setEmail(value);
                          },
                          keyboardType: TextInputType.emailAddress,
                          errorText: _criarContaController.emailError
                        ),
                        SizedBox(height: 25),
                        CustomTextFormFieldWidget(
                          label: 'Insira o nome', 
                          onChanged: _criarContaController.setNome,
                          errorText: _criarContaController.nomeError,
                        ),
                        SizedBox(height: 25),
                        CustomTextFormFieldWidget(
                          label: 'Insira o telefone', 
                          onChanged: _criarContaController.setTelefone,
                        ),
                        SizedBox(height: 25),
                        CustomTextFormFieldWidget(
                          label: 'Insira a senha', 
                          onChanged: _criarContaController.setSenha,
                          obscureText: true,
                          errorText: _criarContaController.senhaError,
                        ),
                        SizedBox(height: 25),
                        CustomSalvarNovaContaButtonComponent(
                          criarContaController: _criarContaController,
                        ),
                        SizedBox(height: 30),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 5,
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(height: 25),
                        CustomPossuoContaButtonComponent()
                      ]
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