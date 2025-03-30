// lib/widgets/custom_movimentacao_baia_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syspig/controller/cadastrar_movimentacao_baia/cadastrar_movimentacao_baia_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CustomMovimentacaoBaiaWidget extends StatefulWidget {
  final OcupacaoModel ocupacao;
  final BaiaModel baia;
  final VoidCallback onClose;
  final Function(BaiaModel) onMovimentarTodosParaMesmaBaia;
  final Function(List<AnimalModel>, BaiaModel) onMovimentarSelecionadosParaMesmaBaia;
  final Function(Map<AnimalModel, BaiaModel>) onMovimentarParaBaiasDiferentes;

  const CustomMovimentacaoBaiaWidget({
    Key? key,
    required this.ocupacao,
    required this.baia,
    required this.onClose,
    required this.onMovimentarTodosParaMesmaBaia,
    required this.onMovimentarSelecionadosParaMesmaBaia,
    required this.onMovimentarParaBaiasDiferentes,
  }) : super(key: key);

  @override
  _CustomMovimentacaoBaiaWidgetState createState() => _CustomMovimentacaoBaiaWidgetState();
}

class _CustomMovimentacaoBaiaWidgetState extends State<CustomMovimentacaoBaiaWidget> {
  final TextEditingController _searchControllerBaia = TextEditingController();
  int _selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MovimentacaoBaiaController>(context);
    final animais = widget.ocupacao.ocupacaoAnimais?.map((oa) => oa.animal!).toList() ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOptionsSelector(),
          const SizedBox(height: 20),
          _buildSelectedOptionContent(controller, animais),
          const SizedBox(height: 20),
          _buildActionButtons(controller, animais),
        ],
      ),
    );
  }

  Widget _buildOptionsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecione o tipo de movimentação:'),
        const SizedBox(height: 10),
        DropdownButton<int>(
          value: _selectedOption,
          items: const [
            DropdownMenuItem(value: 1, child: Text('Todos para mesma baia')),
            DropdownMenuItem(value: 2, child: Text('Selecionar individualmente')),
            DropdownMenuItem(value: 3, child: Text('Cada um para uma baia diferente')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSelectedOptionContent(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    switch (_selectedOption) {
      case 1:
        return _buildTodosParaMesmaBaia(controller);
      case 2:
        return _buildSelecionarIndividualmente(controller, animais);
      case 3:
        return _buildCadaParaBaiaDiferente(controller, animais);
      default:
        return Container();
    }
  }

  Widget _buildTodosParaMesmaBaia(MovimentacaoBaiaController controller) {
    return Column(
      children: [
        const Text('Todos os animais serão movimentados para:'),
        const SizedBox(height: 10),
        CustomTextFormFieldWidget(
          controller: _searchControllerBaia,
          label: 'Buscar Baia',
          hintText: 'Digite o número da baia',
          suffixIcon: _searchControllerBaia.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchControllerBaia.clear();
                    controller.filterBaias('');
                  },
                )
              : const Icon(Icons.search),
          onChanged: (value) => controller.filterBaias(value),
          onTap: () => controller.toggleBaiaSearchFocus(),
        ),
        if (controller.isBaiaSearchFocused && controller.baias.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: controller.baias.length,
              itemBuilder: (context, index) {
                final baia = controller.baias[index];
                return ListTile(
                  title: Text(baia.numero ?? ''),
                  subtitle: Text(baia.vazia ?? true ? 'Vazia' : 'Ocupada'),
                  onTap: () {
                    controller.selectedBaia = baia;
                    controller.toggleBaiaSearchFocus(); // Fecha a busca após seleção
                  },
                );
              },
            ),
          ),
        if (controller.selectedBaia != null) _buildBaiaInfoCard(controller.selectedBaia!),
      ],
    );
  }

  Widget _buildSelecionarIndividualmente(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    return Column(
      children: [
        const Text('Selecione os animais para movimentar:'),
        const SizedBox(height: 10),
        Column(
          children: animais.map((animal) {
            return CheckboxListTile(
              title: Text(animal.numeroBrinco),
              value: controller.selectedAnimals.contains(animal),
              onChanged: (_) => controller.toggleAnimalSelection(animal),
            );
          }).toList(),
        ),
        if (controller.selectedAnimals.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text('Selecione a baia de destino:'),
          const SizedBox(height: 10),
          CustomTextFormFieldWidget(
            controller: _searchControllerBaia,
            label: 'Buscar Baia',
            hintText: 'Digite o número da baia',
            suffixIcon: _searchControllerBaia.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchControllerBaia.clear();
                      controller.filterBaias('');
                    },
                  )
                : const Icon(Icons.search),
            onChanged: (value) => controller.filterBaias(value),
            onTap: () => controller.toggleBaiaSearchFocus(),
          ),
          if (controller.isBaiaSearchFocused && controller.baias.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: controller.baias.length,
                itemBuilder: (context, index) {
                  final baia = controller.baias[index];
                  return ListTile(
                    title: Text(baia.numero ?? ''),
                    subtitle: Text(baia.vazia ?? true ? 'Vazia' : 'Ocupada'),
                    onTap: () {
                      controller.selectedBaia = baia;
                      controller.toggleBaiaSearchFocus(); // Fecha a busca após seleção
                    },
                  );
                },
              ),
            ),
          if (controller.selectedBaia != null) _buildBaiaInfoCard(controller.selectedBaia!),
        ],
      ],
    );
  }

  Widget _buildCadaParaBaiaDiferente(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    return Column(
      children: [
        const Text('Selecione uma baia para cada animal:'),
        const SizedBox(height: 10),
        ...animais.map((animal) {
          final baiaSelecionada = controller.animalBaiaMap[animal];
          return Column(
            children: [
              ListTile(
                title: Text(animal.numeroBrinco),
                trailing: SizedBox(
                  width: 150,
                  child: DropdownButton<BaiaModel>(
                    isExpanded: true,
                    hint: const Text('Selecione'),
                    value: baiaSelecionada,
                    items: controller.baias.map((baia) {
                      return DropdownMenuItem<BaiaModel>(
                        value: baia,
                        child: Text(baia.numero ?? ''),
                      );
                    }).toList(),
                    onChanged: (baia) {
                      controller.setAnimalBaia(animal, baia);
                    },
                  ),
                ),
              ),
              if (baiaSelecionada != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Status: ${baiaSelecionada.vazia ?? true ? 'Vazia' : 'Ocupada'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              const Divider(),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBaiaInfoCard(BaiaModel baia) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Baia selecionada: ${baia.numero}'),
            Text('Status: ${baia.vazia ?? true ? 'Vazia' : 'Ocupada'}'),
            if (baia.capacidade != null) Text('Capacidade: ${baia.capacidade}'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onClose,
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _handleMovimentar(controller, animais),
          child: const Text('Movimentar'),
        ),
      ],
    );
  }

  void _handleMovimentar(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    switch (_selectedOption) {
      case 1:
        if (controller.selectedBaia != null) {
          widget.onMovimentarTodosParaMesmaBaia(controller.selectedBaia!);
        }
        break;
      case 2:
        if (controller.selectedAnimals.isNotEmpty && controller.selectedBaia != null) {
          widget.onMovimentarSelecionadosParaMesmaBaia(controller.selectedAnimals, controller.selectedBaia!);
        }
        break;
      case 3:
        if (controller.animalBaiaMap.isNotEmpty && controller.animalBaiaMap.length == animais.length) {
          widget.onMovimentarParaBaiasDiferentes(controller.animalBaiaMap);
        }
        break;
    }
  }
}