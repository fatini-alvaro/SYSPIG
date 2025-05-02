import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/components/buttons/custom_abrir_tela_adicionar_novo_button_component.dart';
import 'package:syspig/components/cards/custom_movimentacao_card%20copy.dart';
import 'package:syspig/controller/venda/venda_controller.dart';
import 'package:syspig/model/venda_model.dart';
import 'package:syspig/repositories/venda/venda_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/themes/themes.dart';

class VisualizarVendaPage extends StatefulWidget {
  @override
  State<VisualizarVendaPage> createState() {
    return VisualizarVendaPageState();
  }
}

class VisualizarVendaPageState extends State<VisualizarVendaPage> {
  
  final VendaController _vendaController = VendaController(VendaRepositoryImp());
   
  @override
  void initState() {
    super.initState();
    _carregarVendas();
  }

  Future<void> _carregarVendas() async {
    int? fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _vendaController.fetch(fazendaId);
    } else {
      Logger().e('ID da fazenda não encontrado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastro de Vendas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Ajuste a quantidade de espaço desejada
            child: CustomAbrirTelaAdicionarNovoButtonComponent(
              buttonText: 'Cadastrar Venda', 
              onPressed: () {
                Navigator.of(context).pushNamed('/abrirTelaCadastrarVenda');     
              },
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder<List<VendaModel>>(
              valueListenable: _vendaController.vendas,
              builder: (_, list, __) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) => CustomVendaCard(
                    venda: list[idx],      
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
