import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:gasto_0/Models/expense.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:gasto_0/features/auth/providers/auth_provider.dart';

class ReporteGastoScreen extends StatefulWidget {
  const ReporteGastoScreen({super.key});

  @override
  State<ReporteGastoScreen> createState() => _ReporteGastoScreenState();
}

class _ReporteGastoScreenState extends State<ReporteGastoScreen> {
  late DateTimeRange selectedWeek;
  late Future<List<Expense>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedWeek = DateTimeRange(
      start: now.subtract(Duration(days: now.weekday - 1)),
      end: now.add(Duration(days: 7 - now.weekday)),
    );
    _expensesFuture = fetchExpensesOfWeek();
  }
  Future<List<Expense>> fetchExpensesOfWeek() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = await authProvider.getToken();
    final response = await http.get(
      Uri.parse(
        'http://localhost:3000/api/gastos/ver_gastos?start=${selectedWeek.start.toIso8601String()}&end=${selectedWeek.end.toIso8601String()}',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['expenses'] ?? [];
      return data.map((item) => Expense(
        descpription: item['descripcion'] ?? '',
        amount: double.tryParse(item['monto'].toString()) ?? 0.0,
        category: item['categoria'] ?? '',
        date: _parseDate(item['fecha']),
      )).toList();
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

  Future<void> _selectWeek(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedWeek,
      helpText: 'Selecciona la semana',
    );
    if (picked != null) {
      setState(() {
        selectedWeek = picked;
        _expensesFuture = fetchExpensesOfWeek();
      });
    }
  }

  Future<void> _printOrDownloadReport(List<Expense> expensesOfWeek) async {
    final pdf = pw.Document();
    final formatter = DateFormat('dd/MM/yyyy');
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Reporte de Gastos (${formatter.format(selectedWeek.start)} - ${formatter.format(selectedWeek.end)})',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Descripción', 'Monto', 'Categoría', 'Fecha'],
              data: expensesOfWeek.map((e) => [
                e.descpription,
                '\$${e.amount.toStringAsFixed(2)}',
                e.category,
                formatter.format(e.date),
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFE3F2FD)),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              'Total: \$${expensesOfWeek.fold<double>(0, (sum, e) => sum + e.amount).toStringAsFixed(2)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Gastos por Semana'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Semana: ${formatter.format(selectedWeek.start)} - ${formatter.format(selectedWeek.end)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => _selectWeek(context),
                  tooltip: 'Seleccionar semana',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Expense>>(
                future: _expensesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar los gastos'));
                  }
                  final expensesOfWeek = snapshot.data ?? [];
                  if (expensesOfWeek.isEmpty) {
                    return const Center(child: Text('No hay gastos en esta semana'));
                  }
                  return ListView.separated(
                    itemCount: expensesOfWeek.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final e = expensesOfWeek[i];
                      return ListTile(
                        title: Text(e.descpription),
                        subtitle: Text('${e.category} - ${formatter.format(e.date)}'),
                        trailing: Text('\$${e.amount.toStringAsFixed(2)}'),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Expense>>(
                    future: _expensesFuture,
                    builder: (context, snapshot) {
                      final expensesOfWeek = snapshot.data ?? [];
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Imprimir o Descargar PDF'),
                        onPressed: expensesOfWeek.isEmpty
                            ? null
                            : () => _printOrDownloadReport(expensesOfWeek),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}