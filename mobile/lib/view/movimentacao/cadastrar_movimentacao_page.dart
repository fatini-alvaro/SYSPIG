import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_movimentacao/cadastrar_movimentacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarMovimentacaoPage extends StatefulWidget {
  @override
  State<CadastrarMovimentacaoPage> createState() => CadastrarMovimentacaoPageState();
}

class CadastrarMovimentacaoPageState extends State<CadastrarMovimentacaoPage> {
  final CadastrarMovimentacaoController _cadastrarMovimentacaoController = CadastrarMovimentacaoController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<AnimalModel> animais = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  bool _isAnimalSearchFocused = false;
  AnimalModel? animalSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  Future<void> _carregarAnimais() async {
    animais = await _cadastrarMovimentacaoController.getAnimaisFromRepository();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Movimentação'),
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
                controller: _searchControllerAnimal,
                label: 'Selecionar Animal',
                hintText: 'Animal para movimentar',
                suffixIcon: _searchControllerAnimal.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerAnimal.clear();
                            animalSelecionado = null;
                            _isAnimalSearchFocused = false;
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
                            animal.numeroBrinco.toLowerCase().contains(_searchControllerAnimal.text.toLowerCase()))
                        .map((animal) {
                      return ListTile(
                        title: Text('${animal.numeroBrinco}'),
                        onTap: () async {
                          AnimalModel? detalhes = animal.id != null
                              ? await _cadastrarMovimentacaoController.getAnimalDetalhes(animal.id!)
                              : null;
                          setState(() {
                            animalSelecionado = detalhes ?? animal;
                            _searchControllerAnimal.text = animal.numeroBrinco;
                            _isAnimalSearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              if (animalSelecionado != null)
                _buildAnimalInfoCard(animalSelecionado!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalInfoCard(AnimalModel animal) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informações do Animal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Número do Brinco: ${animal.numeroBrinco}'),
            Text('Baia Atual: ${animal.ocupacaoAnimalAtiva?.ocupacao?.baia?.numero ?? "Sem baia vinculada"}'),
            Text('Data de Entrada: ${animal.ocupacaoAnimalAtiva?.dataEntrada != null ? DateFormat('dd/MM/yyyy HH:mm').format(animal.ocupacaoAnimalAtiva!.dataEntrada!) : "Não informado"}'),
            Text('Tempo na Baia: ${animal.ocupacaoAnimalAtiva?.dataEntrada != null ? _calcularTempoNaBaia(animal.ocupacaoAnimalAtiva?.dataEntrada) : "Não informado"}'),
          ],
        ),
      ),
    );
  }

  String _calcularTempoNaBaia(DateTime? dataEntrada) {
    if (dataEntrada == null) return "Não disponível";
    final Duration diferenca = DateTime.now().difference(dataEntrada);
    return "${diferenca.inDays} dias";
  }
}