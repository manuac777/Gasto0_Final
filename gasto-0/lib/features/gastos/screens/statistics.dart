import 'package:flutter/material.dart';
import 'package:gasto_0/Models/expense.dart';
import 'package:gasto_0/features/gastos/widgets/weekly_expenses_chart.dart';
import 'package:gasto_0/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late Future<List<Expense>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = fetchExpenses();
  }

  Future<List<Expense>> fetchExpenses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = await authProvider.getToken();

    final response = await http.get(
      Uri.parse('http://localhost:3000/api/gastos/ver_gastos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['expenses'] ?? [];
      return data
          .map((item) => Expense(
                descpription: item['descripcion'] ?? '',
                amount: double.tryParse(item['monto'].toString()) ?? 0.0,
                category: item['categoria'] ?? '',
                date: _parseDate(item['fecha']),
              ))
          .toList();
    } else {
      throw Exception('Error al cargar los gastos');
    }
  }
  DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } catch (_) {}
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    const containerBgColor = Color.fromARGB(255, 25, 25, 25);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: containerBgColor,
          border: Border.all(color: containerBgColor),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(14.0),
        child: FutureBuilder<List<Expense>>(
          future: _expensesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error al cargar estadísticas',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            final expenses = snapshot.data ?? [];
            if (expenses.isEmpty) {
              return const Center(
                child: Text(
                  'No hay datos estadísticos para mostrar.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return WeeklyExpensesChart(expenses: expenses);
          },
        ),
      ),
    );
  }
}
