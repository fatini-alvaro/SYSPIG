import 'package:flutter/material.dart';
import 'package:mobile/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:mobile/controller/cadastrar_granja/cadastrar_granja_controller.dart';
import 'package:mobile/model/tipo_granja_model.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/custom_text_form_field_widget.dart';

class CadastrarGranjaPage extends StatefulWidget {
  @override
  State<CadastrarGranjaPage> createState() {
    return CadastrarGranjaPageState();
  }
}

class CadastrarGranjaPageState extends State<CadastrarGranjaPage> {
  final CadastrarGranjaController _cadastrarGranjaController =
      CadastrarGranjaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TipoGranjaModel> tipoGranjas = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedTipoGranja = '';
  bool _isTipoGranjaSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _carregarCidades();
  }

  Future<void> _carregarCidades() async {
    tipoGranjas = await _cadastrarGranjaController.getTipoGranjasFromRepository();
    setState(() {});
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Granja'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomTextFormFieldWidget(
                label: 'Nome ou Número',
                hintText: 'Digite uma identificação',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
                onChanged: _cadastrarGranjaController.setDescricao,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Tipo Da Granja',
                  suffixIcon: Icon(Icons.search),
                ),
                // onTap: () {
                //   setState(() {
                //     _isCitySearchFocused = true; // Set the flag to true when the search field is tapped
                //   });
                // },
                // onChanged: (value) {
                //   setState(() {
                //     _selectedCity = value;
                //   });
                // },
              ),

              CustomTextFormFieldWidget(
                label: 'Tipo Da Granja',
                onChanged: _cadastrarGranjaController.setTipoGranja,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    // Adicione outros widgets aqui se necessário
                  ],
                ),
              ),
              CustomSalvarCadastroButtonComponent(buttonText: 'Salvar Granja', rotaTelaAposSalvar:'selecionarGranja'),
            ],
          ),
        ),
      ),
    );
  }
}

