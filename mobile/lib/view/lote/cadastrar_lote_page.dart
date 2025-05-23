import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_lote/cadastrar_lote_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/selecionar_lote/selecionar_lote_page.dart';
import 'package:syspig/widgets/custom_booleanField_widget.dart';
import 'package:syspig/widgets/custom_data_table.dart';
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
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool? _encerrado;

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
      _dataInicio = lote.dataInicio;
      _dataFim = lote.dataFim;
      _encerrado = lote.encerrado ?? false;

      _cadastrarLoteController.setDescricao(lote.descricao);
      _cadastrarLoteController.setNumero(lote.numeroLote);
      _cadastrarLoteController.setDataCriacao(lote.data);
      _cadastrarLoteController.setDataInicio(lote.dataInicio);
      _cadastrarLoteController.setDataFim(lote.dataFim);
      _cadastrarLoteController.setEncerrado(lote.encerrado);

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(height: 20),
                        CustomDateTimeFieldWidget(
                          labelText: 'Data de inicio',
                          initialValue: _dataInicio,
                          enabled: widget.loteId == null,
                          validator: (value) {
                            if (value == null) {
                              return "A data é obrigatória";
                            }
                            return null;
                          },  
                          onChanged: (selectedDate) {
                            setState(() {
                              _dataInicio = selectedDate;
                            });
                            _cadastrarLoteController.setDataInicio(selectedDate);
                          },
                        ),
                        SizedBox(height: 20),
                        CustomDateTimeFieldWidget(
                          labelText: 'Data de Fim',
                          initialValue: _dataFim,
                          enabled: widget.loteId != null,
                          onChanged: (selectedDate) {
                            setState(() {
                              _dataFim = selectedDate;
                            });
                            _cadastrarLoteController.setDataFim(selectedDate);
                          },
                        ),
                        if (widget.loteId != null)
                        SizedBox(height: 20),
                        if (widget.loteId != null)
                        CustomBooleanFieldWidget(
                          label: 'Encerrado?',
                          value: _encerrado,
                          onChanged: (val) {
                            setState(() {
                              _encerrado = val;
                            });
                            _cadastrarLoteController.setEncerrado(val);
                          },
                          validator: (val) {
                            if (val == null) return 'Selecione uma opção';
                            return null;
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
                        CustomDataTable(
                          title: 'Animais adicionados ao lote',
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Nº Brinco',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(label: Text(
                                'Ações',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          data: _cadastrarLoteController.animaisSelecionados,
                          generateRows: (animais) {
                            return animais.map((animal) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(animal.numeroBrinco!)),
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
                            }).toList();
                          },
                        ),
                        SizedBox(height: 20),
                        const Spacer(),
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
            },
          ),
        ),
      ),
    );
  }
}

