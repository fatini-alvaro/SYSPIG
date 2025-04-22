import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syspig/controller/cadastrar_movimentacao_baia/cadastrar_movimentacao_baia_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/widgets/custom_quantidade_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

enum MovimentacaoTipo {
  todosParaMesmaBaia,
  selecionarIndividualmente,
  cadaParaBaiaDiferente,
}

class CustomMovimentacaoBaiaWidget extends StatefulWidget {
  final OcupacaoModel ocupacao;
  final BaiaModel baia;
  final VoidCallback onClose;
  final bool isNascimento;  

  const CustomMovimentacaoBaiaWidget({
    Key? key,
    required this.ocupacao,
    required this.baia,
    required this.onClose,
    this.isNascimento = false,
  }) : super(key: key);

  @override
  State<CustomMovimentacaoBaiaWidget> createState() => _CustomMovimentacaoBaiaWidgetState();
}

class _CustomMovimentacaoBaiaWidgetState extends State<CustomMovimentacaoBaiaWidget> {
  final TextEditingController _searchControllerBaia = TextEditingController();
  MovimentacaoTipo _selectedOption = MovimentacaoTipo.todosParaMesmaBaia;
  bool _isProcessing = false;

  @override
  void dispose() {
    _searchControllerBaia.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MovimentacaoBaiaController>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.isNascimento
            ? _buildNascimentoContent(controller)
            : [
                _buildOptionsSelector(),
                const SizedBox(height: 20),
                _buildSelectedOptionContent(controller, _getAnimais()),
                const SizedBox(height: 20),
                _buildActionButtons(controller, _getAnimais()),
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
        DropdownButton<MovimentacaoTipo>(
          value: _selectedOption,
          items: const [
            DropdownMenuItem(
              value: MovimentacaoTipo.todosParaMesmaBaia,
              child: Text('Todos para mesma baia'),
            ),
            DropdownMenuItem(
              value: MovimentacaoTipo.selecionarIndividualmente,
              child: Text('Selecionar individualmente'),
            ),
            DropdownMenuItem(
              value: MovimentacaoTipo.cadaParaBaiaDiferente,
              child: Text('Cada um para uma baia diferente'),
            ),
          ],
          onChanged: (value) {
            if (!mounted) return;
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
      case MovimentacaoTipo.todosParaMesmaBaia:
        return _buildTodosParaMesmaBaia(controller);
      case MovimentacaoTipo.selecionarIndividualmente:
        return _buildSelecionarIndividualmente(controller, animais);
      case MovimentacaoTipo.cadaParaBaiaDiferente:
        return _buildCadaParaBaiaDiferente(controller, animais);
    }
  }

  Widget _buildTodosParaMesmaBaia(MovimentacaoBaiaController controller) {
    return Consumer<MovimentacaoBaiaController>(
      builder: (context, controller, _) {
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
                        controller.toggleBaiaSearchFocus();
                      },
                    );
                  },
                ),
              ),
            if (controller.selectedBaia != null) _buildBaiaInfoCard(controller.selectedBaia!),
          ],
        );
      },
    );
  }

  Widget _buildSelecionarIndividualmente(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    return Consumer<MovimentacaoBaiaController>(
      builder: (context, controller, _) {
        return Column(
          children: [
            const Text('Selecione os animais para movimentar:'),
            const SizedBox(height: 10),
            Column(
              children: animais.map((animal) {
                return CheckboxListTile(
                  title: Text(animal.numeroBrinco!),
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
                          controller.toggleBaiaSearchFocus();
                        },
                      );
                    },
                  ),
                ),
              if (controller.selectedBaia != null) _buildBaiaInfoCard(controller.selectedBaia!),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCadaParaBaiaDiferente(MovimentacaoBaiaController controller, List<AnimalModel> animais) {
    return Consumer<MovimentacaoBaiaController>(
      builder: (context, controller, _) {
        return Column(
          children: [
            const Text('Selecione uma baia para cada animal:'),
            const SizedBox(height: 10),
            ...animais.map((animal) {
              final baiaSelecionada = controller.animalBaiaMap[animal];
              return Column(
                children: [
                  ListTile(
                    title: Text(animal.numeroBrinco!),
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
      },
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
          onPressed: _isProcessing ? null : widget.onClose,
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _isProcessing ? null : () => _handleMovimentar(controller, animais),
          child: _isProcessing 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Movimentar'),
        ),
      ],
    );
  }

  Future<void> _handleMovimentar(MovimentacaoBaiaController controller, List<AnimalModel> animais) async {
    if (!mounted) return;

    setState(() => _isProcessing = true);

    final animaisParaMovimentar = widget.isNascimento || _selectedOption == MovimentacaoTipo.selecionarIndividualmente
      ? controller.selectedAnimals
      : animais;

    try {
      final success = await controller.movimentarAnimais(
        context,
        animaisParaMovimentar,
        _selectedOption,
        controller.selectedBaia,
        controller.animalBaiaMap,
      );

      if (!mounted) return;

      if (success) {
        widget.onClose();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  List<Widget> _buildNascimentoContent(MovimentacaoBaiaController controller) {
    final totalLeitoes = _getQuantidadeAnimais();

    return [
      Text('Quantidade de leitões disponíveis: $totalLeitoes'),
      const SizedBox(height: 10),

      CustomQuantidadeFormFieldWidget(
        label: 'Quantidade para movimentar',
        hintText: 'Digite a quantidade',
        onChanged: (value) {
          final quantidade = int.tryParse(value) ?? 0;
          if (quantidade <= totalLeitoes) {
            controller.setQuantidadeNascimento(quantidade);
            final animaisSelecionados = _getAnimais().take(quantidade).toList();
            controller.setSelectedAnimals(animaisSelecionados);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quantidade maior que o disponível')),
            );
          }
        },
        controller: controller.quantidadeController,
        maxValue: totalLeitoes
      ),

      const SizedBox(height: 10),

      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () {
            controller.quantidadeController.text = totalLeitoes.toString();
            controller.setQuantidadeNascimento(totalLeitoes);
            final animaisSelecionados = _getAnimais().take(totalLeitoes).toList();
            controller.setSelectedAnimals(animaisSelecionados);
          },
          icon: const Icon(Icons.all_inclusive),
          label: const Text('Movimentar todos'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),

      const SizedBox(height: 20),
      const Text('Selecione a baia de destino:'),
      const SizedBox(height: 10),
      _buildTodosParaMesmaBaia(controller),
      const SizedBox(height: 20),
      _buildActionButtons(controller, controller.selectedAnimals),
    ];
  }

  List<AnimalModel> _getAnimais() {
    final animais = widget.isNascimento
        ? widget.ocupacao.ocupacaoAnimaisNascimento?.map((oa) => oa.animal!).toList() ?? []
        : widget.ocupacao.ocupacaoAnimaisSemNascimento?.map((oa) => oa.animal!).toList() ?? [];

    return animais.where((animal) => animal.status == StatusAnimal.vivo).toList();
  }

  int _getQuantidadeAnimais() {
    return _getAnimais().length;
  }

}