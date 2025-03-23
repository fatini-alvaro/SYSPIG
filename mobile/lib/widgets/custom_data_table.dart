import 'package:flutter/material.dart';
import 'package:syspig/themes/themes.dart';

class CustomDataTable<T> extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) generateRows;
  final List<T> data;

  const CustomDataTable({
    Key? key,
    required this.title,
    required this.columns,
    required this.data,
    required this.generateRows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da tabela estilizado
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity, // Preenche a largura disponível
          constraints: const BoxConstraints(maxHeight: 315),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Permite rolar verticalmente
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Permite rolar horizontalmente
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width, // Garante que a tabela ocupe toda a largura
                  ),
                  child: DataTable(
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    headingRowColor:
                        MaterialStateProperty.all(AppThemes.lightTheme.colorScheme.primary),
                    columns: columns.map((column) {
                      return DataColumn(
                        label: Text(
                          (column.label as Text).data ?? '',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255), // Cor do texto do cabeçalho
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    rows: generateRows(data),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
