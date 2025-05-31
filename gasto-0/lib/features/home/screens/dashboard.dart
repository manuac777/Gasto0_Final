import 'package:flutter/material.dart';
import 'package:gasto_0/Models/user.dart';
import 'package:gasto_0/features/auth/providers/auth_provider.dart';
import 'package:gasto_0/features/home/data.dart'; // Importa aquí
import 'package:gasto_0/features/home/widgets/drawer_menu.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _date = DateTime.now();
  int _tableKey = 0;

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025, 12),
      helpText: 'Selecciona una fecha',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: drawerMenu(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Filtrar por fecha: '),
                      IconButton(
                        onPressed: _selectDate,
                        icon: Icon(Icons.filter_list_alt),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Agregar Gasto: '),
                      IconButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/agregar_gasto');
                          setState(() {
                            _tableKey++;
                          });
                        },
                        icon: Icon(Icons.add_circle_outline),
                      ),
                    ],
                  )
                ],
              ),
              GastosTable(key: ValueKey(_tableKey)),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: authProvider.getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return const Text('Error al cargar el usuario');
                    }

                    final User? user = snapshot.data;
                    return Text(user?.name ?? 'Usuario no encontrado',
                        style: const TextStyle(fontSize: 20));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class GastosTable extends StatefulWidget {
  const GastosTable({Key? key}) : super(key: key);

  @override
  _GastosTableState createState() => _GastosTableState();
}

class _GastosTableState extends State<GastosTable> {
  DataSource? _dataSource;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initDataSource();
  }

  Future<void> _initDataSource() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = await authProvider.getToken();
    _dataSource = DataSource(context, token ?? '');
    await _dataSource!.fetchData();
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant GastosTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initDataSource();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_dataSource == null || _dataSource!.rows.isEmpty) {
      return Center(child: Text('Aún no hay gastos registrados'));
    }
    return PaginatedDataTable(
      header: Text('Gastos'),
      columns: [
        DataColumn(label: Text('Descripcion')),
        DataColumn(label: Text('Monto')),
        DataColumn(label: Text('Categoría')),
        DataColumn(label: Text('Fecha')),
      ],
      source: _dataSource!,
      rowsPerPage: _dataSource!.rows.length < 10
          ? _dataSource!.rows.length == 0
              ? 1
              : _dataSource!.rows.length
          : 10,
    );
  }
}
