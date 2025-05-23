import 'package:flutter/material.dart';
import 'package:syspig/controller/animal/animal_controller.dart';
import 'package:syspig/controller/baia/baia_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
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

  final BaiaController _baiaController = 
      BaiaController(BaiaRepositoryImp());
      
  List<AnimalModel> _nascimentos = [];

  final TextEditingController _quantidadeController = TextEditingController();

  late final Future<OcupacaoModel> Function() getOcupacao;

  int _quantidadeVivos = 0;
  int _quantidadeMortos = 0;

  @override
  void initState() {
    super.initState();
    _carregarMatriz();
    _carregarNascimentos();
  }

  Future<void> _carregarNascimentos() async {
    final ocupacaoAtualizada = await widget.getOcupacao();

    _nascimentos = ocupacaoAtualizada.ocupacaoAnimaisNascimento != null
        ? ocupacaoAtualizada.ocupacaoAnimaisNascimento!
            .map((ocupacaoAnimal) => ocupacaoAnimal.animal!)
            .toList()
        : [];
    
    _quantidadeVivos = _nascimentos.where((animal) => animal.status == StatusAnimal.vivo).length;
    _quantidadeMortos = _nascimentos.where((animal) => animal.status == StatusAnimal.morto).length;
    setState(() {});
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '--/--/---- --:--';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _carregarMatriz() async {
    final ocupacaoAtualizada = await widget.getOcupacao();

    if (ocupacaoAtualizada != null &&  ocupacaoAtualizada.ocupacaoAnimaisSemNascimento?.length != 0) {
      _matriz = ocupacaoAtualizada.ocupacaoAnimaisSemNascimento?[0].animal;
    }
    
    setState(() {});
  }

  DateTime _dataNascimento = DateTime.now();
  int _quantidade = 0;
  StatusAnimal? _statusSelecionado;
  AnimalModel? _matriz;

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
          matrizId: _matriz!.id!,
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

    // Buscar informações atualizadas da baia
    final baiaAtualizada = await _baiaController.fetchBaiaById(widget.baia!.id!);

    if (baiaAtualizada.vazia == true) {
      if (!mounted) return;

      // Mostrar mensagem
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Baia foi encerrada pois está vazia.')),
      );

      // Fechar a tela atual
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }

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
            onPressed: _matriz != null ? () => _salvarNascimento() : null,
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
          SizedBox(height: 5),
          _buildInfoSection(),
          SizedBox(height: 5),
          CustomDataTable(
            title: 'Nascimentos (Total: ${_quantidadeVivos + _quantidadeMortos})',
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

                          // Buscar informações atualizadas da baia
                          final baiaAtualizada = await _baiaController.fetchBaiaById(widget.baia!.id!);

                          if (baiaAtualizada.vazia == true) {
                            if (!mounted) return;

                            // Mostrar mensagem
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Baia foi encerrada pois está vazia.')),
                            );

                            // Fechar a tela atual
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            });
                          }

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

  Widget _buildInfoSection() {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(
              icon: Icons.cake,
              label: "Quantidade de nascimentos vivos",
              value: _quantidadeVivos.toString(),
            ),
            _buildInfoItem(
              icon: Icons.bloodtype,
              label: "Quantidade de nascimentos mortos",
              value: _quantidadeMortos.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

