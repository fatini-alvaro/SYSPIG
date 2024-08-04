import 'package:flutter/material.dart';
import 'package:syspig/components/data_tables/custom_adicionar_nascimento_data_table.dart';

class CustomAdicionarNascimentoWidget extends StatefulWidget {
  final VoidCallback onClose;

  CustomAdicionarNascimentoWidget({required this.onClose});

  @override
  _CustomAdicionarNascimentoWidgetState createState() => _CustomAdicionarNascimentoWidgetState();
}

class _CustomAdicionarNascimentoWidgetState extends State<CustomAdicionarNascimentoWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adicionar Nascimento',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Data e hora',
                  labelText: 'Data e hora do Nascimento',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10), // Espaçamento entre os campos
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Qtd',
                  labelText: 'Qtd',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10), // Espaçamento entre os campos
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Vivo Morto',
                  labelText: 'Vivo Morto',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 5,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            widget.onClose(); // Notify the parent to close the widget
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Adicionar Nascimento',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        CustomAdicionarNascimentoDataTable(),
      ],
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Age',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Role',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        ),
      ],
    );
  }
}
