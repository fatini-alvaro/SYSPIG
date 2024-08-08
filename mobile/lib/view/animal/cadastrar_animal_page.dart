import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_animal/cadastrar_animal_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_dropdown_button_form_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarAnimalPage extends StatefulWidget {

  final AnimalModel? animalParaEditar;

  CadastrarAnimalPage({Key? key, this.animalParaEditar}) : super(key: key);

  @override
  State<CadastrarAnimalPage> createState() {
    return CadastrarAnimalPageState();
  }
}

class CadastrarAnimalPageState extends State<CadastrarAnimalPage> {
  final CadastrarAnimalController _cadastrarAnimalController =
      CadastrarAnimalController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.animalParaEditar != null) {
      _preencherCamposParaEdicao(widget.animalParaEditar!);
    }
  }

  void _preencherCamposParaEdicao(AnimalModel animal) {
    _cadastrarAnimalController.setNascimento(animal.dataNascimento);
    _cadastrarAnimalController.setNumeroBrinco(animal.numeroBrinco);
    _cadastrarAnimalController.setSexo(animal.sexo);
    _cadastrarAnimalController.setStatus(animal.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.animalParaEditar == null
            ? 'Cadastrar Animal'
            : 'Editar Animal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                label: 'Brinco',
                hintText: 'Numero do Brinco',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
                onChanged: _cadastrarAnimalController.setNumeroBrinco,
                initialValue: _cadastrarAnimalController.numeroBrinco,
              ),
              SizedBox(height: 20),
              CustomDropdownButtonFormFieldWidget(
                items: ['Feminino', 'Masculino'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value == 'Feminino' ? 'F' : 'M', // Mapeando para 'F' e 'M'
                    child: Text(value),
                  );
                }).toList(),
                value: _cadastrarAnimalController.sexo,
                labelText: 'Selecione o sexo do animal',
                onChanged: (sexo) {
                  String valorMapeado = sexo == 'Feminino' ? 'F' : 'M'; // Mapeando de 'Feminino' para 'F' e de 'Masculino' para 'M'
                  _cadastrarAnimalController.setSexo(valorMapeado);
                },
                validator: (sexo) {
                  if (sexo == null) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomDropdownButtonFormFieldWidget(
                items: ['Vivo', 'Morto', 'Vendido'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _cadastrarAnimalController.status,
                labelText: 'Selecione o status do animal',
                onChanged: (status) {
                  _cadastrarAnimalController.setStatus(status);
                },
                validator: (status) {
                  if (status == null) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomDateTimeFieldWidget(
                labelText: 'Data de Nascimento',
                onChanged: (data) {
                  _cadastrarAnimalController.setNascimento(data);
                },              
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    // Adicione outros widgets aqui se necessário
                  ],
                ),
              ),
              CustomSalvarCadastroButtonComponent(
                buttonText: widget.animalParaEditar == null
                    ? 'Salvar Animal'
                    : 'Salvar Alterações', 
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.animalParaEditar == null) {
                      _cadastrarAnimalController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushNamed(context, '/selecionarAnimal');
                        }
                      });
                    } else {
                      _cadastrarAnimalController
                          .update(context, widget.animalParaEditar!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushNamed(context, '/selecionarAnimal');
                        }
                      });
                    }
                  }                           
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

