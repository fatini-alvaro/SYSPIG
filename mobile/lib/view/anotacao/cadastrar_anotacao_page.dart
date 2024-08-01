import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_anotacao/cadastrar_anotacao_controller.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/anotacao_model.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/view/selecionar_anotacao/selecionar_anotacao_page.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarAnotacaoPage extends StatefulWidget {
  final AnotacaoModel? anotacaoParaEditar;

  CadastrarAnotacaoPage({Key? key, this.anotacaoParaEditar}) : super(key: key);

  @override
  State<CadastrarAnotacaoPage> createState() {
    return CadastrarAnotacaoPageState();
  }
}

class CadastrarAnotacaoPageState extends State<CadastrarAnotacaoPage> {
  final CadastrarAnotacaoController _cadastrarAnotacaoController =
      CadastrarAnotacaoController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<AnimalModel> animais = [];
  List<BaiaModel> baias = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  TextEditingController _searchControllerBaia = TextEditingController();
  bool _isAnimalSearchFocused = false;
  bool _isBaiaSearchFocused = false;

  final AnimalModel? animal;
  final BaiaModel? baia;

  CadastrarAnotacaoPageState({this.animal, this.baia});

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
    _carregarBaias();
    if (widget.anotacaoParaEditar != null) {
      // Caso seja uma edição, preencha os campos com os dados da granja
      _preencherCamposParaEdicao(widget.anotacaoParaEditar!);
    }
  }

  void _preencherCamposParaEdicao(AnotacaoModel anotacao) {
    _cadastrarAnotacaoController.setDescricao(anotacao.descricao!);
    _cadastrarAnotacaoController.setAnimal(anotacao.animal);
    _searchControllerAnimal.text = anotacao.animal != null ? anotacao.animal!.numeroBrinco : '';
    _cadastrarAnotacaoController.setBaia(anotacao.baia);
    _searchControllerBaia.text = anotacao.baia != null ? anotacao.baia!.numero : '';
  }

  Future<void> _carregarAnimais() async {
    animais = await _cadastrarAnotacaoController.getAnimaisFromRepository();
    setState(() {});
  }

  Future<void> _carregarBaias() async {
    baias = await _cadastrarAnotacaoController.getBaiasFromRepository();
    setState(() {});
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Anotação'),
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
                controller: _searchControllerBaia,
                label: 'Baia',
                hintText: 'Buscar Baia',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  //
                },
                onTap: () {
                  setState(() {
                    _isBaiaSearchFocused = !_isBaiaSearchFocused;
                  });
                },
              ),
              SizedBox(height: 10),
              if (_isBaiaSearchFocused)
                Expanded(
                  child: ListView(
                    children: baias
                        .where((baia) =>
                            baia.numero.toLowerCase().contains(_searchControllerBaia.text.toLowerCase()))
                        .map((baia) {
                      return ListTile(
                        title: Text('${baia.numero}'),
                        onTap: () {
                          _cadastrarAnotacaoController.setBaia(baia);
                          setState(() {
                            _searchControllerBaia.text = '${baia.numero}';
                            _isBaiaSearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _searchControllerAnimal,
                label: 'Animal',
                hintText: 'Buscar Animal',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  //
                },
                onTap: () {
                  setState(() {
                    _isAnimalSearchFocused = !_isAnimalSearchFocused;
                  });
                },
              ),
              SizedBox(height: 10),
              if (_isAnimalSearchFocused) 
                Expanded(
                  child: ListView(
                    children: animais
                        .where((animal) =>
                            animal.numeroBrinco.toLowerCase().contains(_searchControllerAnimal.text.toLowerCase()))
                        .map((animal) {
                      return ListTile(
                        title: Text('${animal.numeroBrinco}'),
                        onTap: () {
                          _cadastrarAnotacaoController.setAnimal(animal);
                          setState(() {
                            _searchControllerAnimal.text = '${animal.numeroBrinco}';
                            _isAnimalSearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                label: 'Descrever Anotação',
                onChanged: _cadastrarAnotacaoController.setDescricao,
                initialValue: _cadastrarAnotacaoController.descricao,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
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
                buttonText: widget.anotacaoParaEditar == null
                    ? 'Salvar Anotação'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarAnotacao',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.anotacaoParaEditar == null) {
                      _cadastrarAnotacaoController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelecionarAnotacaoPage(),
                            ),
                          );
                        }
                      });
                    } else {
                      _cadastrarAnotacaoController
                          .update(context, widget.anotacaoParaEditar!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelecionarAnotacaoPage(),
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

