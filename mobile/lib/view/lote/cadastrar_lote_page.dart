import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_lote/cadastrar_lote_controller.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/lote_model.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/utils/dialogs.dart';
import 'package:mobile/view/selecionar_lote/selecionar_lote_page.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarLotePage extends StatefulWidget {
  final LoteModel? loteParaEditar;

  CadastrarLotePage({Key? key, this.loteParaEditar}) : super(key: key);

  @override
  State<CadastrarLotePage> createState() {
    return CadastrarLotePageState();
  }
}

class CadastrarLotePageState extends State<CadastrarLotePage> {
  final CadastrarLoteController _cadastrarLoteController =
      CadastrarLoteController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<AnimalModel> animais = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  bool _isAnimalSearchFocused = false;

  final AnimalModel? animal;

  CadastrarLotePageState({this.animal});

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
    if (widget.loteParaEditar != null) {
      _preencherCamposParaEdicao(widget.loteParaEditar!);
    }
  }

  void _preencherCamposParaEdicao(LoteModel lote) async {
    // Carregar os animais associados ao lote
    await _cadastrarLoteController.carregarLote(lote);
    setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Lote'),
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
                label: 'Descrição',
                onChanged: _cadastrarLoteController.setDescricao,
                initialValue: _cadastrarLoteController.descricao,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },   
              ),
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                label: 'Numero Lote',
                onChanged: _cadastrarLoteController.setNumero,
                initialValue: _cadastrarLoteController.numero,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },   
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
                buttonText: widget.loteParaEditar == null
                    ? 'Salvar Lote'
                    : 'Salvar Alterações', 
                rotaTelaAposSalvar:'selecionarLote',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    if (widget.loteParaEditar == null) {
                      _cadastrarLoteController
                          .create(context)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelecionarLotePage(),
                            ),
                          );
                        }
                      });
                    } else {
                      _cadastrarLoteController
                          .update(context, widget.loteParaEditar!)
                          .then((resultado) {
                        if (resultado) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelecionarLotePage(),
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

