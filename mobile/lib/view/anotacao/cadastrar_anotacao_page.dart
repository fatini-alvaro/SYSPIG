import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_anotacao/cadastrar_anotacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarAnotacaoPage extends StatefulWidget {
  final int? anotacaoId;

  CadastrarAnotacaoPage({Key? key, this.anotacaoId}) : super(key: key);

  @override
  State<CadastrarAnotacaoPage> createState() => CadastrarAnotacaoPageState();
}

class CadastrarAnotacaoPageState extends State<CadastrarAnotacaoPage> {
  final CadastrarAnotacaoController _cadastrarAnotacaoController =
      CadastrarAnotacaoController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController;

  List<AnimalModel> animais = [];
  List<BaiaModel> baias = [];
  List<OcupacaoModel> ocupacoes = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  TextEditingController _searchControllerBaia = TextEditingController();
  TextEditingController _searchControllerOcupacao = TextEditingController();
  bool _isAnimalSearchFocused = false;
  bool _isBaiaSearchFocused = false;
  bool _isOcupacaoSearchFocused = false;

  final AnimalModel? animal;
  final BaiaModel? baia;
  final OcupacaoModel? ocupacao;
  DateTime? _data;

  CadastrarAnotacaoPageState({this.animal, this.baia, this.ocupacao});

  @override
  void initState() {
    super.initState();

    _descricaoController = TextEditingController();

    _carregarAnimais();
    _carregarBaias();
    _carregarOcupacoes();

    if (widget.anotacaoId != null) {
      _carregarDadosDaAnotacao(widget.anotacaoId!);
    }
  }

  Future<void> _carregarDadosDaAnotacao(int anotacaoId) async {
    final anotacao = await _cadastrarAnotacaoController.fetchAnotacaoById(anotacaoId);
    if (anotacao != null) {
      _preencherCamposParaEdicao(anotacao);
    }
  }

  void _preencherCamposParaEdicao(AnotacaoModel anotacao) {
    setState(() {
      //valores em tela
      _searchControllerAnimal.text = anotacao.animal != null ? anotacao.animal!.numeroBrinco! : '';
      _searchControllerBaia.text = anotacao.baia != null ? anotacao.baia!.numero! : '';
      _searchControllerOcupacao.text = 'Código: ${anotacao.ocupacao?.codigo} - Baia ${anotacao.ocupacao?.baia!.numero}';
      _descricaoController.text = anotacao.descricao!;
      _data = anotacao.data;

      //valores no controller
      _cadastrarAnotacaoController.setDescricao(anotacao.descricao!);
      _cadastrarAnotacaoController.setAnimal(anotacao.animal);    
      _cadastrarAnotacaoController.setBaia(anotacao.baia);
      _cadastrarAnotacaoController.setOcupacao(anotacao.ocupacao);
    });
  }

  Future<void> _carregarAnimais() async {
    animais = await _cadastrarAnotacaoController.getAnimaisFromRepository();
    setState(() {});
  }

  Future<void> _carregarBaias() async {
    baias = await _cadastrarAnotacaoController.getBaiasFromRepository();
    setState(() {});
  }

  Future<void> _carregarOcupacoes() async {
    ocupacoes = await _cadastrarAnotacaoController.getOcupacoesFromRepository();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (widget.anotacaoId != null && _descricaoController.text == '') {
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
        title: Text(widget.anotacaoId == null
            ? 'Cadastrar Anotação'
            : 'Editar Anotação'),
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
                controller: _searchControllerOcupacao,
                label: 'Ocupação',
                hintText: 'Buscar Ocupação',
                suffixIcon: _searchControllerOcupacao.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerOcupacao.clear();
                            _cadastrarAnotacaoController.setOcupacao(null);
                          });
                        },
                      )
                    : Icon(Icons.search),
                onChanged: (value) {
                  setState(() {});
                },
                onTap: () {
                  setState(() {
                    _isOcupacaoSearchFocused = !_isOcupacaoSearchFocused;
                  });
                },
              ),
              if (_isOcupacaoSearchFocused)
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: ocupacoes
                        .where((ocupacao) =>
                            ocupacao.codigo!.toString().contains(_searchControllerOcupacao.text.toLowerCase()))
                        .map((ocupacao) {
                      return ListTile(
                        title: Text('Código: ${ocupacao.codigo} - Baia ${ocupacao.baia!.numero}'),
                        onTap: () {
                          _cadastrarAnotacaoController.setOcupacao(ocupacao);
                          setState(() {
                            _searchControllerOcupacao.text = '${ocupacao.codigo}';
                            _isOcupacaoSearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _searchControllerBaia,
                label: 'Baia',
                hintText: 'Buscar Baia',
                suffixIcon: _searchControllerBaia.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerBaia.clear();
                            _cadastrarAnotacaoController.setBaia(null);
                          });
                        },
                      )
                    : Icon(Icons.search),
                onChanged: (value) {
                  setState(() {});
                },
                onTap: () {
                  setState(() {
                    _isBaiaSearchFocused = !_isBaiaSearchFocused;
                  });
                },
              ),
              if (_isBaiaSearchFocused)
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: baias
                        .where((baia) =>
                            baia.numero!.toLowerCase().contains(_searchControllerBaia.text.toLowerCase()))
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
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _searchControllerAnimal,
                label: 'Animal',
                hintText: 'Buscar Animal',
                suffixIcon: _searchControllerAnimal.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerAnimal.clear();
                            _cadastrarAnotacaoController.setAnimal(null);
                          });
                        },
                      )
                    : Icon(Icons.search),
                onChanged: (value) {
                  setState(() {});
                },
                onTap: () {
                  setState(() {
                    _isAnimalSearchFocused = !_isAnimalSearchFocused;
                  });
                },
              ),
              if (_isAnimalSearchFocused)
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: animais
                        .where((animal) =>
                            animal.numeroBrinco!.toLowerCase().contains(_searchControllerAnimal.text.toLowerCase()))
                        .map((animal) {
                      return ListTile(
                        title: Text('${animal.numeroBrinco}'),
                        onTap: () {
                          _cadastrarAnotacaoController.setAnimal(animal);
                          setState(() {
                            _searchControllerAnimal.text = animal.numeroBrinco!;
                            _isAnimalSearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _descricaoController,
                label: 'Descrição',
                hintText: 'Descrever Anotação',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },   
                onChanged: _cadastrarAnotacaoController.setDescricao,
              ),
              const SizedBox(height: 20),
              CustomDateTimeFieldWidget(
                labelText: 'Data da Anotação',
                initialValue: _data,
                onChanged: (selectedDate) {
                  setState(() {
                    _data = selectedDate;
                  });
                  _cadastrarAnotacaoController.setData(selectedDate);
                },
              ),
              const SizedBox(height: 20),           
              Expanded(
                child: ListView(
                  children: [
                    // Adicione outros widgets aqui se necessário
                  ],
                ),
              ),
              CustomSalvarCadastroButtonComponent(
                buttonText: widget.anotacaoId == null
                    ? 'Salvar Anotação'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarAnotacao',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.anotacaoId == null) {
                      _cadastrarAnotacaoController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarAnotacao');
                        }
                      });
                    } else {
                      _cadastrarAnotacaoController
                          .update(context, widget.anotacaoId!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarAnotacao');
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

