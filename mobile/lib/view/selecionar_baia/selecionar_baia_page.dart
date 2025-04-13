import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_baia_card.dart';
import 'package:syspig/controller/abrir_baia/abrir_baia_controller.dart';
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

  final AbrirBaiaController _abrirbaiaController =
      AbrirBaiaController();

  List<AnimalModel> animais = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  bool _isAnimalSearchFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SelecionarBaiaPageState({this.granja});
   
  @override
  void initState() {
    super.initState();
    _carregarBaias();
    _carregarAnimais();
  }

  Future<void> _carregarBaias() async {
    if (granja != null) {
      _abrirbaiaController.fetchByGranja(granja!.id!);
    } else {
      _abrirbaiaController.fetch();
    }
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

  @override
  Widget build(BuildContext context) {
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
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Nova Baia', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroBaia');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<BaiaModel>>(
              valueListenable: _abrirbaiaController.baias,
              builder: (_, list, __) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 140,
                  ),
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomBaiaCard(
                    baia: list[idx],
                    onTapOcupada: () async {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaiaPage(
                            baiaId: list[idx].id,
                          ),
                        ),
                      );

                      _carregarBaias();
                    },
                    onTapVazia: (){
                      _abrirbaiaController.setBaiaSelecionada(list[idx]);
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
                                          'Abrir Baia: ${list[idx].numero}',
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
                                                  .where((animal) =>
                                                      animal.numeroBrinco!.toLowerCase().contains(_searchControllerAnimal.text.toLowerCase()))
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
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomDataTable(
                                              title: 'Animais para movimentar na baia',
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
                                          ],
                                        ),      
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              // Adicione outros widgets aqui se necessário
                                            ],
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () async {

                                                if (_abrirbaiaController.animaisSelecionados.isEmpty) {
                                                  Dialogs.errorToast(context, 'Selecione pelo menos um animal antes de abrir a baia.');
                                                  return;
                                                }

                                                if (_formKey.currentState!.validate()) {
                                                  _abrirbaiaController
                                                      .abrirBaia(context)
                                                      .then((ocupacaoCriada) {
                                                    if (ocupacaoCriada.id != null) {
                                                      Dialogs.successToast(context, 'Ocupação aberta com sucesso');
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => BaiaPage(
                                                            baiaId: list[idx].id,
                                                          ),
                                                        ),
                                                      );

                                                      _carregarBaias();
                                                    }
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.open_in_browser),
                                              label: Text(
                                                'Abrir Baia ${list[idx].numero}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppThemes.lightTheme.primaryColor,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Fechar o modal
                                              },
                                              icon: Icon(Icons.cancel),
                                              label: Text(
                                                'Cancelar',
                                                style: TextStyle(fontSize: 16),
                                              ),
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
                    } 
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}