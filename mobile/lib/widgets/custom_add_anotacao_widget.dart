import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/anotacao/anotacao_controller.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/controller/cadastrar_anotacao/cadastrar_anotacao_controller.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:syspig/utils/async_handler_util.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CustomAddAnotacaoWidget extends StatefulWidget {
  final VoidCallback onClose;
  final OcupacaoModel ocupacao;
  final BaiaModel baia;

  CustomAddAnotacaoWidget({
    Key? key,
    required this.onClose,
    required this.ocupacao,
    required this.baia,
  }) : super(key: key);

  @override
  _CustomAddAnotacaoWidgetState createState() => _CustomAddAnotacaoWidgetState();
}

class _CustomAddAnotacaoWidgetState extends State<CustomAddAnotacaoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AnotacaoController _anotacaoController =
      AnotacaoController(AnotacaoRepositoryImp());
  final TextEditingController _descriptionController = TextEditingController();
  List<AnimalModel> _animais = [];
  AnimalModel? _animalSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  Future<void> _carregarAnimais() async {
    if (widget.ocupacao.ocupacaoAnimais != null) {
      setState(() {
        _animais = widget.ocupacao.ocupacaoAnimais!
            .map((ocupacaoAnimal) => ocupacaoAnimal.animal!)
            .toList();
      });
    }
  }

  void _salvarAnotacao() async {
    if (!_formKey.currentState!.validate()) return;

    await AsyncHandler.execute(
      context: context,
      action: () async {
        AnotacaoModel anotacao = AnotacaoModel(
          descricao: _descriptionController.text,
          ocupacao: widget.ocupacao,
          baia: widget.baia,
          animal: _animalSelecionado,
          data: DateTime.now(),
        );

        return await _anotacaoController.create(anotacao);
      },
      loadingMessage: 'Salvando anotação...',
      successMessage: 'Anotação salva com sucesso!',
    );

    _descriptionController.clear();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adicionar Anotação',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CustomTextFormFieldWidget(
            controller: _descriptionController,
            label: 'Descrição',
            hintText: 'Digite sua descrição...',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'A descrição não pode estar vazia';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 10),
          Text('Selecione um animal:', style: TextStyle(fontSize: 16)),
          _animais.isNotEmpty
              ? Wrap(
                  children: _animais.map((animal) {
                    return ChoiceChip(
                      label: Text(animal.numeroBrinco),
                      selected: _animalSelecionado == animal,
                      onSelected: (bool selected) {
                        setState(() {
                          _animalSelecionado = selected ? animal : null;
                        });
                      },
                    );
                  }).toList(),
                )
              : Text('Nenhum animal encontrado'),
          SizedBox(height: 20),
          CustomSalvarCadastroButtonComponent(
            buttonText: 'Adicionar Anotação',
            rotaTelaAposSalvar: 'selecionarAnotacao',
            onPressed: () => _salvarAnotacao(),
          ),
        ],
      ),
    );
  }
}
