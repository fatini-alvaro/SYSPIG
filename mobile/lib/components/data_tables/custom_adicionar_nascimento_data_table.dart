import 'package:flutter/material.dart';

List<dynamic> data = [
  {"dataHora": "05:40 23/01/2023", "qtd": 1, "status": "Vivo", "acoes": "Editar ou Excluir"},
  {"dataHora": "06:20 23/01/2023", "qtd": 2, "status": "Mortos", "acoes": "Editar ou Excluir"},
  {"dataHora": "07:40 23/01/2023", "qtd": 1, "status": "Vivo", "acoes": "Editar ou Excluir"},
  {"dataHora": "08:00 23/01/2023", "qtd": 1, "status": "Morto", "acoes": "Editar ou Excluir"},
  {"dataHora": "08:00 23/01/2023", "qtd": 1, "status": "Morto", "acoes": "Editar ou Excluir"},
  {"dataHora": "08:00 23/01/2023", "qtd": 1, "status": "Morto", "acoes": "Editar ou Excluir"},
  {"dataHora": "08:00 23/01/2023", "qtd": 1, "status": "Morto", "acoes": "Editar ou Excluir"},
];


class CustomAdicionarNascimentoDataTable extends StatelessWidget {
  const CustomAdicionarNascimentoDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          columnSpacing: 20, // Ajuste o espaçamento entre as colunas
          headingRowHeight: 50, // Altura da linha de cabeçalho
          dataRowHeight: 60, // Altura das linhas de dados
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  'Data e Hora',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Qtd',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Vivo Morto',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Ações',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          rows: data
            .map(
              (item) => DataRow(cells: [
                DataCell(Text(item['dataHora'])),
                DataCell(Text(item['qtd'].toString())),
                DataCell(Text(item['status'])),
                DataCell(Text(item['acoes'])),
              ]),
            )
            .toList(),
        ),
      ),
    );
  }
}
