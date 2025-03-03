import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_animal/cadastrar_animal_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_dropdown_button_form_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarAnimalPage extends StatefulWidget {
  final int? animalId;

  CadastrarAnimalPage({Key? key, this.animalId}) : super(key: key);

  @override
  State<CadastrarAnimalPage> createState() => CadastrarAnimalPageState();
}

class CadastrarAnimalPageState extends State<CadastrarAnimalPage> {
  final CadastrarAnimalController _cadastrarAnimalController =
      CadastrarAnimalController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _numeroBrincoController;
  DateTime? _dataNascimento;

  @override
  void initState() {
    super.initState();

    _numeroBrincoController = TextEditingController();

    if (widget.animalId != null) {
      _carregarDadosDoAnimal(widget.animalId!);
    }
  }

  Future<void> _carregarDadosDoAnimal(int animalId) async {
    final animal = await _cadastrarAnimalController.fetchAnimalById(animalId);
    if (animal != null) {
      _preencherCamposParaEdicao(animal);
    }
  }

  void _preencherCamposParaEdicao(AnimalModel animal) {
    setState(() {
      //valores em tela
      _numeroBrincoController.text = animal.numeroBrinco;
      _dataNascimento = animal.dataNascimento;

      //valores no controller
      _cadastrarAnimalController.setNumeroBrinco(animal.numeroBrinco);
      _cadastrarAnimalController.setSexo(animal.sexo);
      _cadastrarAnimalController.setStatus(animal.status);
      _cadastrarAnimalController.setNascimento(animal.dataNascimento);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.animalId != null && _numeroBrincoController.text == '') {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemes.lightTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text('Carregando...'),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.animalId == null
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
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _numeroBrincoController,
                label: 'Brinco',
                hintText: 'Número do Brinco',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
                onChanged: _cadastrarAnimalController.setNumeroBrinco,
              ),
              const SizedBox(height: 20),
              CustomDropdownButtonFormFieldWidget(
                items: SexoAnimal.values
                    .map((sexo) => DropdownMenuItem(
                          value: sexo,
                          child: Text(sexoAnimalDescriptions[sexo]!),
                        ))
                    .toList(),
                value: _cadastrarAnimalController.sexo,
                labelText: 'Selecione o sexo do animal',
                onChanged: _cadastrarAnimalController.setSexo,
                validator: (sexo) {
                  if (sexo == null) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDropdownButtonFormFieldWidget(
                items: StatusAnimal.values
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(statusAnimalDescriptions[status]!),
                        ))
                    .toList(),
                value: _cadastrarAnimalController.status,
                labelText: 'Selecione o status do animal',
                onChanged: _cadastrarAnimalController.setStatus,
                validator: (status) {
                  if (status == null) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDateTimeFieldWidget(
                labelText: 'Data de Nascimento',
                initialValue: _dataNascimento,
                onChanged: (selectedDate) {
                  setState(() {
                    _dataNascimento = selectedDate;
                  });
                  _cadastrarAnimalController.setNascimento(selectedDate);
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
                buttonText: widget.animalId == null
                    ? 'Salvar Animal'
                    : 'Salvar Alterações',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.animalId == null) {
                      _cadastrarAnimalController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarAnimal');
                        }
                      });
                    } else {
                      _cadastrarAnimalController
                          .update(context, widget.animalId!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarAnimal');
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

  @override
  void dispose() {
    _numeroBrincoController.dispose();
    super.dispose();
  }
}
