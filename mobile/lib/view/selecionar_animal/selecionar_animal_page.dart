import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/components/cards/custom_registro_card.dart';
import 'package:mobile/controller/animal/animal_controller.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/repositories/animal/animal_repository_imp.dart';
import 'package:mobile/services/prefs_service.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/utils/dialogs.dart';
import 'package:mobile/view/animal/cadastrar_animal_page.dart';

class SelecionarAnimalPage extends StatefulWidget {
  @override
  State<SelecionarAnimalPage> createState() {
    return SelecionarAnimalPageState();
  }
}

class SelecionarAnimalPageState extends State<SelecionarAnimalPage> {
  
  final AnimalController _animalController = AnimalController(AnimalRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  Future<void> _carregarAnimais() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _animalController.fetch(fazendaId);
    } else {
      print('ID da fazenda não encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Animais'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Novo Animal', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastroAnimal');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<AnimalModel>>(
              valueListenable: _animalController.animais,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomRegistroCard(
                    descricao: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brinco: ${list[idx].numeroBrinco}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    onEditarPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastrarAnimalPage(
                            animalParaEditar: list[idx],
                          ),
                        ),
                      );
                    },
                    onExcluirPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Confirmar exclusão'),
                          content: Text('Tem certeza de que deseja excluir o animal ${list[idx].numeroBrinco}?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // Fechar o diálogo de confirmação
                                await _animalController.delete(context, list[idx].id!);

                                 Dialogs.successToast(context, 'Animal excluída com sucesso!');

                                 _carregarAnimais();
                              },
                              child: Text('Confirmar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Fechar o diálogo de confirmação
                              },
                              child: Text('Cancelar'),
                            ),
                          ],
                        ),
                      );
                    },   
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
