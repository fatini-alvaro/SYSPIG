import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_granja/cadastrar_granja_controller.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/model/tipo_granja_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_dropdown_button_form_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarGranjaPage extends StatefulWidget {
  final int? granjaId;

  CadastrarGranjaPage({Key? key, this.granjaId}) : super(key: key);

  @override
  State<CadastrarGranjaPage> createState() => CadastrarGranjaPageState();
}

class CadastrarGranjaPageState extends State<CadastrarGranjaPage> {
  final CadastrarGranjaController _cadastrarGranjaController =
      CadastrarGranjaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController;

  List<TipoGranjaModel> tipoGranjas = [];

  @override
  void initState() {
    super.initState();

    _descricaoController = TextEditingController();

    _carregarTipoGranjas();

    if (widget.granjaId != null) {
      _carregarDadosDaGranja(widget.granjaId!);
    }
  }

  Future<void> _carregarDadosDaGranja(int granjaId) async {
    final granja = await _cadastrarGranjaController.fetchGranjaById(granjaId);
    if (granja != null) {
      _preencherCamposParaEdicao(granja);
    }
  }

  void _preencherCamposParaEdicao(GranjaModel granja) {
    setState(() { 
      _descricaoController.text = granja.descricao;

      _cadastrarGranjaController.setDescricao(granja.descricao);
      _cadastrarGranjaController.setTipoGranja(granja.tipoGranja);
    });
  }

  Future<void> _carregarTipoGranjas() async {
    tipoGranjas = await _cadastrarGranjaController.getTipoGranjasFromRepository();
    setState(() {});
  }  

  @override
  Widget build(BuildContext context) {

    if (widget.granjaId != null && _descricaoController.text == '') {
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
        title: Text(widget.granjaId == null
            ? 'Cadastrar Granja'
            : 'Editar Granja'),
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
                controller: _descricaoController,
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
                value: _cadastrarGranjaController.tipoGranja,
                labelText: 'Selecione o tipo de granja',
                onChanged: (tipoGranja) {
                  _cadastrarGranjaController.setTipoGranja(tipoGranja);
                },
                validator: (tipoGranja) {
                  if (tipoGranja == null) {
                    return 'Selecione o tipo de granja';
                  }
                  return null;
                },
                isEnabled: widget.granjaId == null,
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
                buttonText: widget.granjaId == null
                    ? 'Salvar Granja'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarGranja',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.granjaId == null) {
                      _cadastrarGranjaController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarGranja');
                        }
                      });
                    } else {
                      _cadastrarGranjaController
                          .update(context, widget.granjaId!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarGranja');
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

