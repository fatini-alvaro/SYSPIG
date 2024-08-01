import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/components/cards/custom_baia_card.dart';
import 'package:mobile/controller/baia/baia_controller.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/repositories/baia/baia_repository_imp.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/utils/dialogs.dart';
import 'package:mobile/view/baia/baia_page.dart';
import 'package:mobile/view/baia/cadastrar_baia_page.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

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
  final BaiaController _baiaController = BaiaController(BaiaRepositoryImp());

  List<AnimalModel> animais = [];
  TextEditingController _searchController = TextEditingController();
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
      _baiaController.fetch(granja!.id!);
    }
  }

  Future<void> _carregarAnimais() async {
    animais = await _baiaController.getAnimaisFromRepository();
    setState(() {});
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastrarBaiaPage(granja: granja),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<BaiaModel>>(
              valueListenable: _baiaController.baias,
              builder: (_, list, __) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomBaiaCard(
                    baia: list[idx],
                    onTapOcupada: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaiaPage(
                            ocupacao: list[idx].ocupacao,
                          ),
                        ),
                      );
                    },
                    onTapVazia: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setStateModal) {
                            return SingleChildScrollView(
                              child: Container(
                                height: 300,
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
                                        controller: _searchController,
                                        label: 'Animal',
                                        hintText: 'Buscar Animal',
                                        suffixIcon: Icon(Icons.search),
                                        onChanged: (value) {
                                        },
                                        onTap: () {
                                          setStateModal(() {
                                            _isAnimalSearchFocused = !_isAnimalSearchFocused;
                                          });
                                        },
                                        validator: (animal) {
                                          if (animal == "") {
                                            return 'Selecione o animal';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      if (_isAnimalSearchFocused)
                                        Expanded(
                                          child: ListView(
                                            children: animais
                                                .where((animal) =>
                                                    animal.numeroBrinco.toLowerCase().contains(_searchController.text.toLowerCase()))
                                                .map((animal) {
                                              return ListTile(
                                                title: Text('${animal.numeroBrinco}'),
                                                onTap: () {
                                                  _baiaController.setAnimal(animal);
                                                  setStateModal(() {
                                                    _searchController.text = '${animal.numeroBrinco}';
                                                    _isAnimalSearchFocused = false;
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
                                      ButtonBar(
                                        alignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                _baiaController
                                                    .callCriarOcupacao(list[idx], _baiaController.animal!)
                                                    .then((ocupacaoCriada) {
                                                  if (ocupacaoCriada.id != null) {
                                                    Dialogs.successToast(context, 'Ocupação aberta com sucesso');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => BaiaPage(
                                                          ocupacao: ocupacaoCriada,
                                                        ),
                                                      ),
                                                    );
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
                    ),
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