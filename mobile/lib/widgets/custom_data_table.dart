import 'package:flutter/material.dart';
import 'package:syspig/themes/themes.dart';

class CustomDataTable<T> extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) generateRows;
  final List<T> data;
  final double maxTableHeight;

  const CustomDataTable({
    Key? key,
    required this.title,
    required this.columns,
    required this.data,
    required this.generateRows,
    this.maxTableHeight = 315,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: maxTableHeight),
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
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: _buildDataTable(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return DataTable(
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
      rows: generateRows(data),
    );
  }
}
