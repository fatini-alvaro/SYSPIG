import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:mobile/controller/animal/animal_controller.dart';
import 'package:mobile/repositories/animal/animal_repository_imp.dart';
import 'package:mobile/themes/themes.dart';

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
    _animalController.fetch();
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
              caminhoTelaCadastro: 'abrirTelaCadastroAnimal',
            ),
          ),
          SizedBox(height: 15),
          // Expanded(
          //   child: ValueListenableBuilder<List<GranjaModel>>(
          //     valueListenable: _granjaController.granjas,
          //     builder: (_, list, __) {
          //       return ListView.builder(
          //         itemCount: list.length,
          //         itemBuilder: (_, idx) => CustomGranjaRegistroCard(
          //           granja: list[idx],
          //           onEditarPressed: () {
          //             // Lógica para abrir a tela de edição
          //           },
          //           onExcluirPressed: () {
          //             // Lógica para excluir
          //           },
          //           caminhoTelaAoClicar: 'home'
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
