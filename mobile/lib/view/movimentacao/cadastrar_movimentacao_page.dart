import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_movimentacao/cadastrar_movimentacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
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
  List<BaiaModel> baias = [];
  TextEditingController _searchControllerAnimal = TextEditingController();
  TextEditingController _searchControllerBaia = TextEditingController();
  bool _isAnimalSearchFocused = false;
  bool _isBaiaSearchFocused = false;
  AnimalModel? animalSelecionado;
  BaiaModel? baiaSelecionada;
  OcupacaoModel? ocupacaoBaiaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
    _carregarBaias();
  }

  Future<void> _carregarAnimais() async {
    animais = await _cadastrarMovimentacaoController.getAnimaisFromRepository();
    setState(() {});
  }

  Future<void> _carregarBaias() async {
    baias = await _cadastrarMovimentacaoController.getBaiasFromRepository();
    setState(() {});
  }

  Future<void> _selecionarBaia(BaiaModel baia) async {
    final ocupacao = await _cadastrarMovimentacaoController.getOcupacaoByBaia(baia.id!);
    setState(() {
      baiaSelecionada = baia;
      ocupacaoBaiaSelecionada = ocupacao;
      _searchControllerBaia.text = baia.numero ?? '';
      _isBaiaSearchFocused = false;
    });
    _cadastrarMovimentacaoController.setBaiaDestino(baia);
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
                            animal.numeroBrinco!.toLowerCase().contains(_searchControllerAnimal.text.toLowerCase()))
                        .map((animal) {
                      return ListTile(
                        title: Text('${animal.numeroBrinco}'),
                        onTap: () async {
                          AnimalModel? detalhes = animal.id != null
                              ? await _cadastrarMovimentacaoController.getAnimalDetalhes(animal.id!)
                              : null;
                          setState(() {
                            animalSelecionado = detalhes ?? animal;
                            _searchControllerAnimal.text = animal.numeroBrinco!;
                            _isAnimalSearchFocused = false;
                          });
                          _cadastrarMovimentacaoController.setAnimal(animalSelecionado);
                        },
                      );
                    }).toList(),
                  ),
                ),
              if (animalSelecionado != null)
                _buildAnimalInfoCard(animalSelecionado!),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                controller: _searchControllerBaia,
                label: 'Selecionar Baia de Destino',
                hintText: 'Baia para movimentar o animal',
                suffixIcon: _searchControllerBaia.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerBaia.clear();
                            baiaSelecionada = null;
                            ocupacaoBaiaSelecionada = null;
                            _isBaiaSearchFocused = false;
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
                            (baia.numero ?? '').toLowerCase().contains(_searchControllerBaia.text.toLowerCase()))
                        .map((baia) {
                      return ListTile(
                        title: Text('${baia.numero}'),
                        subtitle: Text(baia.vazia ?? true ? 'Vazia' : 'Ocupada'),
                        onTap: () => _selecionarBaia(baia),
                      );
                    }).toList(),
                  ),
                ),
              if (baiaSelecionada != null)
                _buildBaiaInfoCard(baiaSelecionada!, ocupacaoBaiaSelecionada),
              const Spacer(),
              CustomSalvarCadastroButtonComponent(
                buttonText: 'Movimentar Animal',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _cadastrarMovimentacaoController
                        .movimentarAnimal(context)
                        .then((resultado) {
                      if (resultado) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/selecionarMovimentacao');
                      }
                    });
                  }
                },
              ),
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

  Widget _buildBaiaInfoCard(BaiaModel baia, OcupacaoModel? ocupacao) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informações da Baia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Número da Baia: ${baia.numero}'),
            Text('Capacidade: ${baia.capacidade ?? "Não informada"}'),
            if (ocupacao != null) ...[
              Text('Status: ${ocupacao.status?.toString().split('.').last ?? "Não informado"}'),
              Text('Código: ${ocupacao.codigo ?? "Não informado"}'),
              if (ocupacao.ocupacaoAnimaisSemNascimento != null && ocupacao.ocupacaoAnimaisSemNascimento!.isNotEmpty)
                Text('Animais na Baia: ${ocupacao.ocupacaoAnimaisSemNascimento!.length}'),
            ] else
              Text('Status: Vazia'),
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