import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_baia_card.dart';
import 'package:syspig/controller/abrir_baia/abrir_baia_controller.dart';
import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/utils/dialogs.dart';
import 'package:syspig/view/baia/baia_page.dart';
import 'package:syspig/widgets/custom_data_table.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class SelecionarBaiaPage extends StatefulWidget {
  final GranjaModel? granja;

  SelecionarBaiaPage({this.granja});

  @override
  State<SelecionarBaiaPage> createState() {
    return SelecionarBaiaPageState(granja: granja);
  }
}

class SelecionarBaiaPageState extends State<SelecionarBaiaPage> {
  final GranjaModel? granja;

  final AbrirBaiaController _abrirbaiaController = AbrirBaiaController();

  List<AnimalModel> animais = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  bool _isAnimalSearchFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? _tipoGranjaSelecionado;

  SelecionarBaiaPageState({this.granja});

  @override
  void initState() {
    super.initState();
    _carregarBaias();
    _carregarAnimais();
  }

  Future<void> _carregarBaias() async {
    if (granja != null) {
      await _abrirbaiaController.fetchByGranja(granja!.id!);
    } else {
      await _abrirbaiaController.fetch();
    }
    setState(() {});
  }

  Future<void> _carregarAnimais() async {
    animais = await _abrirbaiaController.getAnimaisFromRepository();
    setState(() {});
  }

  void _toggleSelecaoAnimal(AnimalModel animal) {
    if (_abrirbaiaController.animaisSelecionados.any((a) => a.id == animal.id)) {
      Dialogs.infoToast(context, 'Animal já selecionado');
    } else {
      _abrirbaiaController.adicionarAnimal(animal);
    }
  }

  void _removerAnimal(AnimalModel animal) {
    _abrirbaiaController.removerAnimal(animal);
  }

  String _getTipoGranjaName(int? tipoId) {
    if (tipoId == null) return 'OUTRAS';
    
    final entry = tipoGranjaIdToInt.entries.firstWhere(
      (e) => e.value == tipoId,
      orElse: () => MapEntry(TipoGranjaId.gestacao, 1), // default
    );
    
    return entry.key.name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    List<BaiaModel> listaFiltrada = _abrirbaiaController.baias.value.where((baia) {
      if (_tipoGranjaSelecionado == null) return true;
      return baia.granja?.tipoGranja!.id == _tipoGranjaSelecionado;
    }).toList();

    // Agrupar baias por tipo de granja
    final Map<int?, List<BaiaModel>> baiasAgrupadas = {};
    for (var baia in listaFiltrada) {
      final tipoId = baia.granja?.tipoGranja?.id;
      if (!baiasAgrupadas.containsKey(tipoId)) {
        baiasAgrupadas[tipoId] = [];
      }
      baiasAgrupadas[tipoId]!.add(baia);
    }

    // Ordenar os grupos pelo tipoId (opcional)
    final sortedKeys = baiasAgrupadas.keys.toList()
      ..sort((a, b) => (a ?? 0).compareTo(b ?? 0));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Baias'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAbrirTelaAdicionarNovoButtonComponent(
                  buttonText: 'Cadastrar Nova Baia',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/abrirTelaCadastroBaia');
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<int>(
                  value: _tipoGranjaSelecionado,
                  hint: Text("Filtrar por Tipo de Granja"),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('TODOS'),
                    ),
                    ...tipoGranjaIdToInt.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.value,
                        child: Text(entry.key.name.toUpperCase()),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tipoGranjaSelecionado = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView(
              children: sortedKeys.map((tipoId) {
                final baiasDoGrupo = baiasAgrupadas[tipoId]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        _getTipoGranjaName(tipoId),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 2,
                        mainAxisExtent: 150,
                      ),
                      itemCount: baiasDoGrupo.length,
                      itemBuilder: (_, idx) => CustomBaiaCard(
                        baia: baiasDoGrupo[idx],
                        onTapOcupada: () async {
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BaiaPage(
                                baiaId: baiasDoGrupo[idx].id,
                              ),
                            ),
                          );
                          _carregarBaias();
                        },
                        onTapVazia: () {
                          _abrirbaiaController.setBaiaSelecionada(baiasDoGrupo[idx]);
                          _abrirbaiaController.animaisSelecionados.clear();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setStateModal) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      height: 585,
                                      padding: EdgeInsets.all(16),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              'Abrir Baia: ${baiasDoGrupo[idx].numero}',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            CustomTextFormFieldWidget(
                                              controller: _searchControllerAnimal,
                                              label: 'Animal',
                                              hintText: 'Buscar Animal',
                                              suffixIcon: _searchControllerAnimal.text.isNotEmpty
                                                  ? IconButton(
                                                      icon: Icon(Icons.clear),
                                                      onPressed: () {
                                                        setStateModal(() {
                                                          _searchControllerAnimal.clear();
                                                        });
                                                      },
                                                    )
                                                  : Icon(Icons.search),
                                              onChanged: (value) {
                                                setStateModal(() {});
                                              },
                                              onTap: () {
                                                setStateModal(() {
                                                  _isAnimalSearchFocused = !_isAnimalSearchFocused;
                                                });
                                              },
                                            ),
                                            if (_isAnimalSearchFocused)
                                              SizedBox(
                                                height: 200,
                                                child: ListView(
                                                  children: animais
                                                      .where((animal) => animal.numeroBrinco!.toLowerCase().contains(
                                                          _searchControllerAnimal.text.toLowerCase()))
                                                      .map((animal) {
                                                    return ListTile(
                                                      title: Text('${animal.numeroBrinco}'),
                                                      onTap: () {
                                                        setStateModal(() {
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
                                              title: 'Animais para movimentar na baia',
                                              columns: const [
                                                DataColumn(
                                                  label: Text(
                                                    'Nº Brinco',
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Ações',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                              data: _abrirbaiaController.animaisSelecionados,
                                              generateRows: (animais) {
                                                return animais.map((animal) {
                                                  return DataRow(
                                                    cells: [
                                                      DataCell(Text(animal.numeroBrinco!)),
                                                      DataCell(
                                                        ElevatedButton.icon(
                                                          onPressed: () {
                                                            setStateModal(() {
                                                              _removerAnimal(animal);
                                                            });
                                                          },
                                                          icon: Icon(Icons.delete, color: Colors.white),
                                                          label: Text('Excluir', style: TextStyle(color: Colors.white)),
                                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList();
                                              },
                                            ),
                                            Expanded(child: ListView()),
                                            ButtonBar(
                                              alignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: () async {
                                                    if (_abrirbaiaController.animaisSelecionados.isEmpty) {
                                                      Dialogs.errorToast(context,
                                                          'Selecione pelo menos um animal antes de abrir a baia.');
                                                      return;
                                                    }

                                                    if (_formKey.currentState!.validate()) {
                                                      _abrirbaiaController.abrirBaia(context).then((ocupacaoCriada) {
                                                        if (ocupacaoCriada.id != null) {
                                                          Dialogs.successToast(context, 'Ocupação aberta com sucesso');
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BaiaPage(baiaId: baiasDoGrupo[idx].id),
                                                            ),
                                                          );
                                                          _carregarBaias();
                                                        }
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(Icons.open_in_browser),
                                                  label: Text('Abrir Baia ${baiasDoGrupo[idx].numero}',
                                                      style: TextStyle(fontSize: 16)),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppThemes.lightTheme.primaryColor,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                ),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Icons.cancel),
                                                  label: Text('Cancelar', style: TextStyle(fontSize: 16)),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}