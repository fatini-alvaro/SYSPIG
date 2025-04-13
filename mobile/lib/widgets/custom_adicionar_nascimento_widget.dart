import 'package:flutter/material.dart';
import 'package:syspig/controller/animal/animal_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/utils/async_handler_util.dart';
import 'package:syspig/widgets/custom_data_table.dart';
import 'package:syspig/widgets/custom_date_time_field_widget.dart';
import 'package:syspig/widgets/custom_dropdown_button_form_field_widget.dart';
import 'package:syspig/widgets/custom_quantidade_field_widget.dart';

class CustomAdicionarNascimentoWidget extends StatefulWidget {
  final VoidCallback onClose;
  final BaiaModel baia;
  final Future<OcupacaoModel> Function() getOcupacao;

  CustomAdicionarNascimentoWidget({
    Key? key,
    required this.onClose,
    required this.baia,
    required this.getOcupacao,
  }) : super(key: key);


  @override
  _CustomAdicionarNascimentoWidgetState createState() => _CustomAdicionarNascimentoWidgetState();
}

class _CustomAdicionarNascimentoWidgetState extends State<CustomAdicionarNascimentoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AnimalController _animalController =
      AnimalController(AnimalRepositoryImp());
      
  List<AnimalModel> _nascimentos = [];

  final TextEditingController _quantidadeController = TextEditingController();

  late final Future<OcupacaoModel> Function() getOcupacao;

  @override
  void initState() {
    super.initState();
    _carregarNascimentos();
  }

  Future<void> _carregarNascimentos() async {
    final ocupacaoAtualizada = await widget.getOcupacao();
    _nascimentos = ocupacaoAtualizada.ocupacaoAnimaisNascimento != null
        ? ocupacaoAtualizada.ocupacaoAnimaisNascimento!
            .map((ocupacaoAnimal) => ocupacaoAnimal.animal!)
            .toList()
        : [];
    setState(() {});
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '--/--/---- --:--';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  DateTime _dataNascimento = DateTime.now();
  int _quantidade = 0;
  StatusAnimal? _statusSelecionado;

  void _salvarNascimento() async {
    if (!_formKey.currentState!.validate()) return;

    await AsyncHandler.execute(
      context: context,
      action: () async {
        return await _animalController.createNascimentos(
          data: _dataNascimento,
          quantidade: _quantidade,
          status: _statusSelecionado!,
          baia: widget.baia,
        );
      },
      loadingMessage: 'Salvando nascimento...',
      successMessage: 'Nascimento salvo com sucesso!',
    );

    // Limpar os campos após salvar
    setState(() {
      _quantidade = 0;
      _quantidadeController.clear();
      _statusSelecionado = null;
      _dataNascimento = DateTime.now();
    });

    await _carregarNascimentos();
  }

  void _excluirNascimento(AnimalModel animal) async{

    await AsyncHandler.execute(
      context: context,
      action: () async {
        return await _animalController.deleteNascimento(animal.id!);
      },
      loadingMessage: 'Excluindo nascimento...',
      successMessage: 'Nascimento excluido com sucesso!',
    );

    await _carregarNascimentos();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adicionar Nascimento',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomDateTimeFieldWidget(
                  labelText: 'Data de Nascimento',
                  initialValue: _dataNascimento,
                  showTime: true,
                  onChanged: (selectedDate) {
                    setState(() {
                      _dataNascimento = selectedDate!;
                    });
                  },
                ),
              ),
              SizedBox(width: 10), // Espaçamento entre os campos
              Expanded(
                child: CustomQuantidadeFormFieldWidget(
                  label: 'Quantidade',
                  hintText: 'Quantidade de nascidos',
                  controller: _quantidadeController,
                  onChanged: (value) {
                    setState(() {
                      _quantidade = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Campo obrigatório';
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed <= 0) return 'Informe uma quantidade válida';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10), // Espaçamento entre os campos
              Expanded(
                child: CustomDropdownButtonFormFieldWidget<StatusAnimal>(
                  items: StatusAnimal.values
                      .where((status) => status == StatusAnimal.vivo || status == StatusAnimal.morto)
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(statusAnimalDescriptions[status]!),
                          ))
                      .toList(),
                  value: _statusSelecionado,
                  labelText: 'Status',
                  onChanged: (value) {
                    setState(() {
                      _statusSelecionado = value;
                    });
                  },
                  validator: (status) {
                    if (status == null) {
                      return 'Campo Obrigatório';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 5,
              minimumSize: Size(MediaQuery.of(context).size.width, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () => _salvarNascimento(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Adicionar Nascimento',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          CustomDataTable(
            title: 'Nascimentos',
            maxTableHeight: 950,
            columns: const [
              DataColumn(
                label: Text(
                  'Data e Hora',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Qtd',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(label: Text(
                  'Excluir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            data: _nascimentos,
            generateRows: (animais) {
              return animais.map((animal) {
                return DataRow(
                  cells: [
                    DataCell(Text(_formatarData(animal.dataNascimento))),
                    DataCell(Text('1')),
                    DataCell(
                      DropdownButton<StatusAnimal>(
                        value: animal.status,
                        items: StatusAnimal.values
                            .where((status) => status == StatusAnimal.vivo || status == StatusAnimal.morto)
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(statusAnimalDescriptions[status]!),
                                ))
                            .toList(),
                        onChanged: (novoStatus) async {
                          if (novoStatus == null || novoStatus == animal.status) return;
                          
                          await AsyncHandler.execute(
                            context: context,
                            action: () async {
                              await _animalController.atualizarStatusNascimento(animal.id!, novoStatus);
                            },
                            loadingMessage: 'Atualizando status...',
                            successMessage: 'Status atualizado com sucesso!',
                          );

                          await _carregarNascimentos();
                        },
                      ),
                    ),
                    DataCell(
                      IconButton(
                        onPressed: () {
                           setState(() {                                      
                            _excluirNascimento(animal);
                            });
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        ),
                      )
                    ),
                  ],
                );
              }).toList();
            },
          )
          // CustomAdicionarNascimentoDataTable(),
        ],
      ),
    );
  }
}

