import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_baia/cadastrar_baia_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarBaiaPage extends StatefulWidget {
  final int? baiaId;

  CadastrarBaiaPage({Key? key, this.baiaId}) : super(key: key);

  @override
  State<CadastrarBaiaPage> createState() => CadastrarBaiaPageState();
}

class CadastrarBaiaPageState extends State<CadastrarBaiaPage> {
  final CadastrarBaiaController _cadastrarBaiaController =
      CadastrarBaiaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _numeroController;

  List<GranjaModel> granjas = [];
  TextEditingController _searchControllerGranja = TextEditingController();
  bool _isGranjaSearchFocused = false;

  final GranjaModel? granja;

  CadastrarBaiaPageState({this.granja});

  @override
  void initState() {
    super.initState();

    _numeroController = TextEditingController();

    _carregarGranjas();

    if (widget.baiaId != null) {
      _carregarDadosDaBaia(widget.baiaId!);
    }
  }

  Future<void> _carregarDadosDaBaia(int baiaId) async {
    final baia = await _cadastrarBaiaController.fetchBaiaById(baiaId);
    if (baia != null) {
      _preencherCamposParaEdicao(baia);
    }
  }

  void _preencherCamposParaEdicao(BaiaModel baia) {
    setState(() {
      _searchControllerGranja.text = baia.granja != null ? baia.granja!.descricao : '';
      _numeroController.text = baia.numero!;

      _cadastrarBaiaController.setGranja(baia.granja); 
    });
  }

  Future<void> _carregarGranjas() async {
    granjas = await _cadastrarBaiaController.getGranjasFromRepository();
    setState(() {});
  }  

  @override
  Widget build(BuildContext context) {

    if (widget.baiaId != null && _numeroController.text == '') {
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
        title: Text(widget.baiaId == null
            ? 'Cadastrar Baia'
            : 'Editar Baia'),
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
                controller: _numeroController,
                label: 'Baia',
                hintText: 'Número da Baia',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },   
                onChanged: _cadastrarBaiaController.setNumero,
              ),
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _searchControllerGranja,
                label: 'Granja',
                hintText: 'Buscar Granja',
                suffixIcon: _searchControllerGranja.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerGranja.clear();
                            _cadastrarBaiaController.setGranja(null);
                          });
                        },
                      )
                    : Icon(Icons.search),
                onChanged: (value) {
                  setState(() {});
                },
                onTap: () {
                  setState(() {
                    _isGranjaSearchFocused = !_isGranjaSearchFocused;
                  });
                },
              ),
              if (_isGranjaSearchFocused)
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: granjas
                        .where((granja) =>
                            granja.descricao.toLowerCase().contains(_searchControllerGranja.text.toLowerCase()))
                        .map((granja) {
                      return ListTile(
                        title: Text(granja.descricao),
                        onTap: () {
                          _cadastrarBaiaController.setGranja(granja);
                          setState(() {
                            _searchControllerGranja.text = granja.descricao;
                            _isGranjaSearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
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
                buttonText: widget.baiaId == null
                    ? 'Salvar Baia'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarBaia',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.baiaId == null) {
                      _cadastrarBaiaController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarBaia');
                        }
                      });
                    } else {
                      _cadastrarBaiaController
                          .update(context, widget.baiaId!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarBaia');
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

