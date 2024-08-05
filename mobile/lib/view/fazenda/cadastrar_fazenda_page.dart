import 'package:flutter/material.dart';
import 'package:syspig/components/buttons/custom_salvar_cadastro_button_component.dart';
import 'package:syspig/controller/cadastrar_fazenda/cadastrar_fazenda_controller.dart';
import 'package:syspig/model/cidade_model.dart';
import 'package:syspig/themes/themes.dart';
import 'package:syspig/widgets/custom_text_field_widget.dart';
import 'package:syspig/widgets/custom_text_form_field_widget.dart';

class CadastrarFazendaPage extends StatefulWidget {
  @override
  State<CadastrarFazendaPage> createState() {
    return CadastrarFazendaPageState();
  }
}

class CadastrarFazendaPageState extends State<CadastrarFazendaPage> {
  final CadastrarFazendaController _cadastrarFazendaController =
      CadastrarFazendaController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<CidadeModel> cidades = [];
  TextEditingController _searchController = TextEditingController();
  bool _isCitySearchFocused = false;

  @override
  void initState() {
    super.initState();
    _carregarCidades();
  }

  Future<void> _carregarCidades() async {
    cidades = await _cadastrarFazendaController.getCidadesFromRepository();
    setState(() {});
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text('Cadastrar Fazenda'),
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
                label: 'Nome',
                hintText: 'Digite o Nome da Fazenda',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
                onChanged: _cadastrarFazendaController.setNome,
              ),
              SizedBox(height: 20),
              CustomTextFieldWidget(
                controller: _searchController,
                label: 'Cidade',
                hintText: 'Buscar Cidade',
                suffixIcon: Icon(Icons.search),
                onChanged: (value) {
                  //
                },
                onTap: () {
                  setState(() {
                    _isCitySearchFocused = true; // Set the flag to true when the search field is tapped
                  });
                },
              ),
              SizedBox(height: 10),
              if (_isCitySearchFocused) 
                Expanded(
                  child: ListView(
                    children: cidades
                        .where((cidade) =>
                            cidade.nome.toLowerCase().contains(_searchController.text.toLowerCase()))
                        .map((cidade) {
                      return ListTile(
                        title: Text('${cidade.nome} - ${cidade.uf?.nome}'),
                        onTap: () {
                          _cadastrarFazendaController.setCidade(cidade);
                          setState(() {
                            _searchController.text = '${cidade.nome} - ${cidade.uf?.nome}';
                            _isCitySearchFocused = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    // 
                  ],
                ),
              ),
              CustomSalvarCadastroButtonComponent(
                buttonText: 'Salvar Fazenda', 
                rotaTelaAposSalvar:'selecionarFazenda',
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {
                    _cadastrarFazendaController
                        .create(context)
                        .then((resultado) {
                          if (resultado) {
                            Navigator.of(context)
                                .pushReplacementNamed('/selecionarFazenda');
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
}

