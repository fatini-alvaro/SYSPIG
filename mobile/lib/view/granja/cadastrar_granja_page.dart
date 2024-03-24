import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_granja/cadastrar_granja_controller.dart';
import 'package:mobile/model/tipo_granja_model.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_dropdown_button_form_field_widget.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarGranjaPage extends StatefulWidget {
  @override
  State<CadastrarGranjaPage> createState() {
    return CadastrarGranjaPageState();
  }
}

class CadastrarGranjaPageState extends State<CadastrarGranjaPage> {
  final CadastrarGranjaController _cadastrarGranjaController =
      CadastrarGranjaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TipoGranjaModel> tipoGranjas = [];
  TipoGranjaModel? _tipoGranjaSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarTipoGranjas();
  }

  Future<void> _carregarTipoGranjas() async {
    tipoGranjas = await _cadastrarGranjaController.getTipoGranjasFromRepository();
    setState(() {});
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Granja'),
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
                label: 'Descrição/Nome',
                hintText: 'Digite uma identificação',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
                onChanged: _cadastrarGranjaController.setDescricao,
              ),
              SizedBox(height: 20),
              CustomDropdownButtonFormFieldWidget(
                items: tipoGranjas.map((tipoGranja) {
                  return DropdownMenuItem<TipoGranjaModel>(
                    value: tipoGranja,
                    child: Text(tipoGranja.descricao),
                  );
                }).toList(),
                value: _tipoGranjaSelecionado,
                labelText: 'Selecione o tipo de granja',
                onChanged: (tipoGranja) {
                  _cadastrarGranjaController.setTipoGranja(tipoGranja);
                  setState(() {
                    _tipoGranjaSelecionado = tipoGranja;
                  });
                },
                validator: (tipoGranja) {
                  if (tipoGranja == null) {
                    return 'Selecione o tipo de granja';
                  }
                  return null;
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
                buttonText: 'Salvar Fazenda', 
                rotaTelaAposSalvar:'selecionarFazenda',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    _cadastrarGranjaController
                        .create(context)
                        .then((resultado) {
                          if (resultado) {
                            Navigator.of(context)
                                .pushReplacementNamed('/selecionarGranja');
                          }
                        });
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

