import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_movimentacao/cadastrar_movimentacao_controller.dart';
import 'package:syspig/controller/cadastrar_venda/cadastrar_venda_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_com_leitoes_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_data_table.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_peso_form_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';
import 'package:syspig/widgets/custom_valor_monetario_form_field_widget.dart';

class CadastrarVendaPage extends StatefulWidget {
  @override
  State<CadastrarVendaPage> createState() => CadastrarVendaPageState();
}

class CadastrarVendaPageState extends State<CadastrarVendaPage> {
  final CadastrarVendaController _cadastrarVendaController = CadastrarVendaController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<BaiaComLeitoesModel> baias = [];
  TextEditingController _searchControllerBaia = TextEditingController();
  bool _isBaiaSearchFocused = false;

  DateTime? _data;

  @override
  void initState() {
    super.initState();
    _carregarCreches();
  }

  Future<void> _carregarCreches() async {
    baias = await _cadastrarVendaController.getBaiasCrecheComLeitoesFromRepository();
    setState(() {});
  }

  Future<void> _selecionarBaia(BaiaComLeitoesModel baia) async {
    final ocupacao = await _cadastrarVendaController.getOcupacaoByBaia(baia.id!);
    
    final jaAdicionada = _cadastrarVendaController.baias.any((b) => b.id == baia.id);
    if (!jaAdicionada) {
      baia.ocupacao = ocupacao;
      setState(() {
        _cadastrarVendaController.baias.add(baia);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A baia ${baia.numero} já foi adicionada.')),
      );
    }

    setState(() {
      _searchControllerBaia.clear();
      _isBaiaSearchFocused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Venda'),
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
                controller: _searchControllerBaia,
                label: 'Selecionar Baia com leitões',
                hintText: 'Digite o número da baia',
                suffixIcon: _searchControllerBaia.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchControllerBaia.clear();
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
              const SizedBox(height: 20),
              CustomDataTable(
                title: 'Leitões Para Venda',
                columns: const [
                  DataColumn(
                    label: Text(
                      'Baia',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Qtde Leitões',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(label: Text(
                      'Remover',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                data: _cadastrarVendaController.baias,
                generateRows: (baias) {
                  return baias.map((baia) {
                    return DataRow(
                      cells: [
                        DataCell(Text(baia.numero ?? 'Não informado')),
                        DataCell(Text((baia.ocupacao?.ocupacaoAnimaisNascimentoVivos.length ?? 'Não informado').toString())),
                        DataCell(
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {                                      
                                baias.remove(baia);
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
              const SizedBox(height: 10),
              Card(
                color: AppThemes.lightTheme.colorScheme.primary,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.piggyBank, color: Colors.white, size: 32),
                  title: Text(
                    'Total de leitões selecionados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  subtitle: Text(
                    '$totalLeitoes leitões para venda',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              if (totalLeitoes > 0 &&
                _cadastrarVendaController.peso != null &&
                _cadastrarVendaController.valor != null)
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(top: 0, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Medias da venda',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Peso médio por leitão: ${(_cadastrarVendaController.peso! / totalLeitoes).toStringAsFixed(2)} kg',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Valor médio por leitão: ${NumberFormat.simpleCurrency(locale: "pt_BR").format(_cadastrarVendaController.valor! / totalLeitoes)}',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPesoFormFieldWidget(
                label: 'Peso Total dos Leitões',
                hintText: 'Digite o peso total',
                onChanged: (value) {
                  final peso = double.tryParse(value);
                  _cadastrarVendaController.setPeso(peso);
                  setState(() {
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  final valorDouble = double.tryParse(value);
                  if (valorDouble == null || valorDouble <= 0) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomValorMonetarioFormFieldWidget(
                label: 'Valor Total da Venda',
                hintText: 'Digite o valor total',
                onChanged: (value) {
                  _cadastrarVendaController.setValor(value);
                  setState(() {
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  final valorDouble = double.tryParse(
                    value.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim(),
                  );
                  if (valorDouble == null || valorDouble <= 0) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDateTimeFieldWidget(
                labelText: 'Data da Venda',
                initialValue: _data,
                onChanged: (selectedDate) {
                  setState(() {
                    _data = selectedDate;
                  });
                  _cadastrarVendaController.setData(selectedDate);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const Spacer(),
              CustomSalvarCadastroButtonComponent(
                buttonText: 'Cadastrar Venda',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _cadastrarVendaController
                        .cadastrarVenda(context)
                        .then((resultado) {
                      if (resultado) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/visualizarVenda');
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

  Widget _buildBaiaInfoCard(BaiaComLeitoesModel baia, OcupacaoModel? ocupacao) {
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
            if (ocupacao != null) ...[
              Text('Status: ${ocupacao.status?.toString().split('.').last ?? "Não informado"}'),
              Text('Código: ${ocupacao.codigo ?? "Não informado"}'),
              if (ocupacao.ocupacaoAnimaisNascimentoVivos != null && ocupacao.ocupacaoAnimaisNascimentoVivos!.isNotEmpty)
                Text('Leitões na Baia: ${ocupacao.ocupacaoAnimaisNascimentoVivos!.length}'),
            ] else
              Text('Status: Vazia'),
          ],
        ),
      ),
    );
  }

  int get totalLeitoes {
    return _cadastrarVendaController.baias.fold(0, (total, baia) {
      return total + (baia.ocupacao?.ocupacaoAnimaisNascimentoVivos.length ?? 0);
    });
  }

}