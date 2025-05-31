import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class _Row {
  final String cellA;
  final String cellB;
  final String cellC;
  final String cellD;

  _Row(this.cellA, this.cellB, this.cellC, this.cellD);

  bool selected = false;
}

class DataSource extends DataTableSource {
  final BuildContext context;
  final String token; 
  late List<_Row> rows;
  int _selectedCount = 0;

  DataSource(this.context, this.token) {
    rows = [];
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/gastos/ver_gastos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    //print('STATUS: ${response.statusCode}');
    //print('BODY: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['expenses'] ?? [];
      //print('DATA DECODED: $data');
      rows = data
          .map((item) => _Row(
                (item['descripcion'] ?? '').toString(),
                '\$ ${(item['monto'] ?? '').toString()}',
                (item['categoria'] ?? '').toString(),
                (item['fecha'] ?? '').toString(),
              ))
          .toList();
    } else {
      rows = [];
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    final row = rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.cellA)),
        DataCell(Text(row.cellB)),
        DataCell(Text(row.cellC)),
        DataCell(Text(row.cellD)),
      ],
    );
  }

  @override
  int get rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
