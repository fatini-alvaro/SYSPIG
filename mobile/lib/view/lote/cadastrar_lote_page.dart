import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_lote/cadastrar_lote_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/selecionar_lote/selecionar_lote_page.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarLotePage extends StatefulWidget {
  final int? loteId;

  CadastrarLotePage({Key? key, this.loteId}) : super(key: key);

  @override
  State<CadastrarLotePage> createState() {
    return CadastrarLotePageState();
  }
}

class CadastrarLotePageState extends State<CadastrarLotePage> {
  final CadastrarLoteController _cadastrarLoteController =
      CadastrarLoteController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController;
  late TextEditingController _numeroLoteController;
  DateTime? _dataCriacao;

  List<AnimalModel> animais = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  bool _isAnimalSearchFocused = false;

  final AnimalModel? animal;

  CadastrarLotePageState({this.animal});

  @override
  void initState() {
    super.initState();

    _descricaoController = TextEditingController();
    _numeroLoteController = TextEditingController();

    _carregarAnimais();
    if (widget.loteId != null) {
      _carregarDadosDoLote(widget.loteId!);
    }
  }

  Future<void> _carregarDadosDoLote(int loteId) async {
    final lote = await _cadastrarLoteController.fetchLoteById(loteId);
    if (lote != null) {
      _preencherCamposParaEdicao(lote);
    }
  }

  void _preencherCamposParaEdicao(LoteModel lote) async {
    setState(() {
      _descricaoController.text = lote.descricao!;
      _numeroLoteController.text = lote.numeroLote!;
      _dataCriacao = lote.data;

      _cadastrarLoteController.setDescricao(lote.descricao);
      _cadastrarLoteController.setNumero(lote.numeroLote);
      _cadastrarLoteController.setDataCriacao(lote.data);

      // Adicionando os animais do lote ao controlador
      lote.loteAnimais?.forEach((loteAnimal) {
        var animal = AnimalModel(
          id: loteAnimal.animal?.id,
          numeroBrinco: loteAnimal.animal!.numeroBrinco,
          dataNascimento: loteAnimal.animal!.dataNascimento,
          sexo: loteAnimal.animal!.sexo,
          status: loteAnimal.animal!.status,
        );
        _cadastrarLoteController.adicionarAnimal(animal); // Adiciona o animal no controlador
      });
    });
  }

  Future<void> _carregarAnimais() async {
    animais = await _cadastrarLoteController.getAnimaisFromRepository();
    setState(() {});
  }

  void _toggleSelecaoAnimal(AnimalModel animal) {
    if (_cadastrarLoteController.animaisSelecionados.any((a) => a.id == animal.id)) {
      Dialogs.infoToast(context, 'Animal já selecionado');
    } else {
      _cadastrarLoteController.adicionarAnimal(animal);
    }
  }

  void _removerAnimal(AnimalModel animal) {
    _cadastrarLoteController.removerAnimal(animal);
  }

  @override
  Widget build(BuildContext context) {

    if (widget.loteId != null && _descricaoController.text == '') {
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
        title: Text(widget.loteId == null
            ? 'Cadastrar Lote'
            : 'Editar Lote'),
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
                label: 'Descrição',
                hintText: 'Descrição do Lote',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },   
                onChanged: _cadastrarLoteController.setDescricao,
              ),
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _numeroLoteController,
                label: 'Número Lote',
                hintText: 'Número do Lote',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },   
                onChanged: _cadastrarLoteController.setNumero,
              ),
              const SizedBox(height: 20),
              CustomDateTimeFieldWidget(
                labelText: 'Data de Criação/Chegada',
                initialValue: _dataCriacao,
                onChanged: (selectedDate) {
                  setState(() {
                    _dataCriacao = selectedDate;
                  });
                  _cadastrarLoteController.setDataCriacao(selectedDate);
                },
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 10),
              if (_isAnimalSearchFocused) 
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: animais
                        .where((animal) =>
                            animal.numeroBrinco.toLowerCase().contains(_searchControllerAnimal.text.toLowerCase()))
                        .map((animal) {
                      return ListTile(
                        title: Text('${animal.numeroBrinco}'),
                        onTap: () {
                          setState(() {                            
                          _toggleSelecaoAnimal(animal);
                          _isAnimalSearchFocused = !_isAnimalSearchFocused;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Animais adicionados ao lote',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: 315,
                    ),
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(
                              'Nº Brinco',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(label: Text(
                              'Ações',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: _cadastrarLoteController.animaisSelecionados.map((animal) {
                          return DataRow(
                            cells: [
                              DataCell(Text(animal.numeroBrinco)),
                              DataCell(
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {                                      
                                    _removerAnimal(animal);
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  label: Text(
                                    'Excluir',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),           
              Expanded(
                child: ListView(
                  children: [
                    //
                  ],
                ),
              ),
              CustomSalvarCadastroButtonComponent(
                buttonText: widget.loteId == null
                    ? 'Salvar Lote'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarLote',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.loteId == null) {
                      _cadastrarLoteController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarLote');
                        }
                      });
                    } else {
                      _cadastrarLoteController
                          .update(context, widget.loteId!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/selecionarLote');
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

