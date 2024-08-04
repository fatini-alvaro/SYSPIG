import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_baia/cadastrar_baia_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/view/selecionar_baia/selecionar_baia_page.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarBaiaPage extends StatefulWidget {
  final BaiaModel? baiaParaEditar;
  final GranjaModel? granja;

  CadastrarBaiaPage({Key? key, this.baiaParaEditar, this.granja}) : super(key: key);

  @override
  State<CadastrarBaiaPage> createState() {
    return CadastrarBaiaPageState(granja: granja);
  }
}

class CadastrarBaiaPageState extends State<CadastrarBaiaPage> {
  final CadastrarBaiaController _cadastrarBaiaController =
      CadastrarBaiaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<GranjaModel> granjas = [];
  TextEditingController _searchController = TextEditingController();
  bool _isGranjaSearchFocused = false;

  final GranjaModel? granja;

  CadastrarBaiaPageState({this.granja});

  @override
  void initState() {
    super.initState();
    _carregarGranjas();
    if (granja != null) {
      _cadastrarBaiaController.setGranja(granja);
      _searchController.text = granja!.descricao;
    }
    if (widget.baiaParaEditar != null) {
      // Caso seja uma edição, preencha os campos com os dados da granja
      _preencherCamposParaEdicao(widget.baiaParaEditar!);
    }
  }

  void _preencherCamposParaEdicao(BaiaModel baia) {
    _cadastrarBaiaController.setNumero(baia.numero);
    _cadastrarBaiaController.setGranja(baia.granja);
  }

  Future<void> _carregarGranjas() async {
    granjas = await _cadastrarBaiaController.getGranjasFromRepository();
    setState(() {});
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Baia'),
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
                label: 'Baia',
                hintText: 'Numero da Baia',
                onChanged: _cadastrarBaiaController.setNumero,  
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },            
              ),
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _searchController,
                label: 'Granja',
                hintText: 'Buscar Granja',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  //
                },
                onTap: () {
                  setState(() {
                    _isGranjaSearchFocused = !_isGranjaSearchFocused;
                  });
                },
                validator: (granja) {
                  if (granja == "") {
                    return 'Selecione o tipo de granja';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              if (_isGranjaSearchFocused) 
                Expanded(
                  child: ListView(
                    children: granjas
                        .where((granja) =>
                            granja.descricao.toLowerCase().contains(_searchController.text.toLowerCase()))
                        .map((granja) {
                      return ListTile(
                        title: Text('${granja.descricao}'),
                        onTap: () {
                          _cadastrarBaiaController.setGranja(granja);
                          setState(() {
                            _searchController.text = '${granja.descricao}';
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
                buttonText: widget.baiaParaEditar == null
                    ? 'Salvar Baia'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarBaia',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.baiaParaEditar == null) {
                      _cadastrarBaiaController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelecionarBaiaPage(granja: granja),
                            ),
                          );
                        }
                      });
                    } else {
                      _cadastrarBaiaController
                          .update(context, widget.baiaParaEditar!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelecionarBaiaPage(granja: granja),
                            ),
                          );
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

