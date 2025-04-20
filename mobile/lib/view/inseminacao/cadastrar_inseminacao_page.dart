import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_inseminacao/cadastrar_inseminacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/inseminacao_model.dart';
import 'package:syspig/model/lote_animal_model.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_data_table.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarInseminacaoPage extends StatefulWidget {
  @override
  State<CadastrarInseminacaoPage> createState() => CadastrarInseminacaoPageState();
}

class CadastrarInseminacaoPageState extends State<CadastrarInseminacaoPage> {
  final CadastrarInseminacaoController _cadastrarInseminacaoController = CadastrarInseminacaoController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<LoteModel> lotes = [];
  TextEditingController _searchControllerLote = TextEditingController();
  LoteModel? loteSelecionado;
  bool _isLoteSearchFocused = false;

  List<AnimalModel> porcos = [];
  TextEditingController _searchControllerPorco = TextEditingController();
  AnimalModel? porcoSelecionado;
  bool _isPorcoSearchFocused = false;

  List<BaiaModel> baiasInseminacao = [];
  TextEditingController _searchControllerBaiaInseminacao= TextEditingController();
  BaiaModel? baiaInseminacaoSelecionado;
  bool _isBaiaInseminacaoSearchFocused = false;

  DateTime? _data;

  List<LoteAnimalModel> loteAnimaisDisponiveis = [];
  List<LoteAnimalModel> loteAnimaisSelecionados = [];

  @override
  void initState() {
    super.initState();
    _carregarLotes();
    _carregarPorcos();
    _carregarBaiasDeInseminacao();
  }

  Future<void> _carregarLotes() async {
    lotes = await _cadastrarInseminacaoController.getLotesFromRepository();
    setState(() {});
  }

  Future<void> _carregarPorcos() async {
    porcos = await _cadastrarInseminacaoController.getPorcosFromRepository();
    setState(() {});
  }

  Future<void> _carregarBaiasDeInseminacao() async {
    baiasInseminacao = await _cadastrarInseminacaoController.getListByFazendaAndTipo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Inseminação'),
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
                        const SizedBox(height: 20),
                        CustomTextFormFieldWidget(
                          controller: _searchControllerLote,
                          label: 'Selecionar Lote',
                          hintText: 'Lotes',
                          validator: (value) {
                            // add email validation
                            if (value == null || value.isEmpty) {
                              return 'Informe o lote';
                            }
                            return null;
                          },
                          suffixIcon: _searchControllerLote.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchControllerLote.clear();
                                      loteSelecionado = null;
                                      _isLoteSearchFocused = false;
                                      loteAnimaisDisponiveis = [];
                                      loteAnimaisSelecionados.clear();
                                      _cadastrarInseminacaoController.inseminacoes.clear();
                                    });
                                  },
                                )
                              : Icon(Icons.search),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onTap: () {
                            setState(() {
                              _isLoteSearchFocused = !_isLoteSearchFocused;
                            });
                          },
                        ),
                        if (_isLoteSearchFocused)
                          SizedBox(
                            height: 200,
                            child: ListView(
                              children: lotes
                                  .where((lote) =>
                                      lote.numeroLote!.toLowerCase().contains(_searchControllerLote.text.toLowerCase()))
                                  .map((lote) {
                                return ListTile(
                                  title: Text('${lote.numeroLote}'),
                                  onTap: () {
                                    setState(() {
                                      loteSelecionado = lote;
                                      _searchControllerLote.text = lote.numeroLote!;
                                      _isLoteSearchFocused = false;
                                      loteAnimaisDisponiveis = lote.loteAnimais ?? [];
                                      loteAnimaisSelecionados.clear(); // limpa os já selecionados se mudar o lote
                                    });
                                    _cadastrarInseminacaoController.setLote(loteSelecionado);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        if (loteSelecionado != null)
                        _buildLoteInfoCard(loteSelecionado!),
                        const SizedBox(height: 20),
                        CustomTextFormFieldWidget(
                          controller: _searchControllerPorco,
                          label: 'Selecionar Porco',
                          hintText: 'Porcos',
                          suffixIcon: _searchControllerPorco.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchControllerPorco.clear();
                                      porcoSelecionado = null;
                                      _isPorcoSearchFocused = false;
                                    });
                                  },
                                )
                              : Icon(Icons.search),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onTap: () {
                            setState(() {
                              _isPorcoSearchFocused = !_isPorcoSearchFocused;
                            });
                          },
                        ),
                        const SizedBox(height: 20),                
                        if (_isPorcoSearchFocused)
                          SizedBox(
                            height: 200,
                            child: ListView(
                              children: porcos
                                  .where((porco) =>
                                      porco.numeroBrinco!.toLowerCase().contains(_searchControllerPorco.text.toLowerCase()))
                                  .map((porco) {
                                return ListTile(
                                  title: Text('${porco.numeroBrinco}'),
                                  onTap: () {
                                    setState(() {
                                      porcoSelecionado = porco;
                                      _searchControllerPorco.text = porco.numeroBrinco!;
                                      _isPorcoSearchFocused = false;
                                    });
                                    _cadastrarInseminacaoController.setPorco(porcoSelecionado);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        CustomTextFormFieldWidget(
                          controller: _searchControllerBaiaInseminacao,
                          label: 'Selecionar Baia de Inseminação',
                          hintText: 'Baias',
                          suffixIcon: _searchControllerBaiaInseminacao.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchControllerBaiaInseminacao.clear();
                                      baiaInseminacaoSelecionado = null;
                                      _isBaiaInseminacaoSearchFocused = false;
                                    });
                                  },
                                )
                              : Icon(Icons.search),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onTap: () {
                            setState(() {
                              _isBaiaInseminacaoSearchFocused = !_isBaiaInseminacaoSearchFocused;
                            });
                          },
                        ),
                        const SizedBox(height: 20),                
                        if (_isBaiaInseminacaoSearchFocused)
                          SizedBox(
                            height: 200,
                            child: ListView(
                              children: baiasInseminacao
                                .where((baia) =>
                                  baia.numero!.toLowerCase().contains(_searchControllerBaiaInseminacao.text.toLowerCase()) &&
                                  !_cadastrarInseminacaoController.inseminacoes.any((inseminacao) => inseminacao.baia?.id == baia.id))
                                .map((baia) {
                                return ListTile(
                                  title: Text('${baia.numero}'),
                                  onTap: () {
                                    setState(() {
                                      baiaInseminacaoSelecionado = baia;
                                      _searchControllerBaiaInseminacao.text = baia.numero!;
                                      _isBaiaInseminacaoSearchFocused = false;
                                    });
                                    _cadastrarInseminacaoController.setBaiaInseminacao(baiaInseminacaoSelecionado);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        CustomDateTimeFieldWidget(
                          labelText: 'Data da inseminação',
                          initialValue: _data,
                          onChanged: (selectedDate) {
                            setState(() {
                              _data = selectedDate;
                            });
                            _cadastrarInseminacaoController.setData(selectedDate);
                          },
                        ),
                        if (loteSelecionado != null && loteAnimaisDisponiveis.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text("Selecionar Animais do Lote", style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              ...loteAnimaisDisponiveis
                              .where((lote) => lote.inseminado == false)
                              .map((lote) {
                                return ListTile(
                                  title: Text('${lote.animal?.numeroBrinco ?? 'Sem nome'}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      if (baiaInseminacaoSelecionado == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Selecione uma baia antes de adicionar o animal.')),
                                        );
                                        return;
                                      }
                                      
                                      if (_data == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Selecione a data da inseminação.')),
                                        );
                                        return;
                                      }
                  
                                      final jaExiste = _cadastrarInseminacaoController.inseminacoes.any(
                                        (i) => i.porcaInseminada?.id == lote.animal?.id,
                                      );
                  
                                      final baiaJaUsada = _cadastrarInseminacaoController.inseminacoes.any(
                                        (i) => i.baia?.id == baiaInseminacaoSelecionado?.id,
                                      );
                  
                                      if (jaExiste) {
                                        // já existe a porca na lista
                                        return;
                                      }
                  
                                      if (baiaJaUsada) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Esta baia já foi usada para outro animal.')),
                                        );
                                        return;
                                      }
                  
                                      setState(() {
                                        _cadastrarInseminacaoController.inseminacoes.add(InseminacaoModel(
                                          id: null,
                                          porcoDoador: porcoSelecionado,
                                          porcaInseminada: lote.animal,
                                          loteAnimal: lote,
                                          lote: loteSelecionado,
                                          baia: baiaInseminacaoSelecionado,
                                          data: _data,
                                          createdBy: null,
                                          createdAt: null,
                                          updatedBy: null,
                                          updatedAt: null,
                                        ));
                  
                                        // Limpa a baia após o uso
                                        baiaInseminacaoSelecionado = null;
                                        _searchControllerBaiaInseminacao.clear();
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        const SizedBox(height: 20),
                        CustomDataTable(
                          title: 'Animais selecionados Para inseminar',
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Matriz',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Porco',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Baia',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(label: Text(
                                'Remover',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          data: _cadastrarInseminacaoController.inseminacoes,
                          generateRows: (inseminacoes) {
                            return inseminacoes.map((inseminacao) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(inseminacao.porcaInseminada!.numeroBrinco!)),
                                  DataCell(Text(inseminacao.porcoDoador?.numeroBrinco ?? 'Não informado')),
                                  DataCell(Text(inseminacao.baia!.numero!)),
                                  DataCell(
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {                                      
                                          inseminacoes.remove(inseminacao);
                                        });
                                      },
                                      icon: Icon(Icons.delete, color: Colors.white),
                                      label: Text(
                                        '-',
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
                        const Spacer(),
                        CustomSalvarCadastroButtonComponent(
                          buttonText: 'Salvar',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (loteSelecionado == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Selecione um lote')),
                                );
                                return;
                              }

                              if (_data == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Selecione a data da inseminação')),
                                );
                                return;
                              }

                              final dataLote = loteSelecionado?.dataInicio ?? DateTime.now(); // ou outro campo de data do lote

                              if (_data!.isBefore(dataLote)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('A data da inseminação não pode ser anterior à data do lote (${DateFormat('dd/MM/yyyy').format(dataLote)}).')),
                                );
                                return;
                              }

                              _cadastrarInseminacaoController
                                  .cadastrarInseminacoes(context)
                                  .then((resultado) {
                                if (resultado) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, '/selecionarInseminacao');
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
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoteInfoCard(LoteModel lote) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informações do Lote', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Text('Data de Inicio: ${lote.dataInicio != null ? DateFormat('dd/MM/yyyy HH:mm').format(lote.dataInicio!) : "Não informado"}'),
          ],
        ),
      ),
    );
  }
}