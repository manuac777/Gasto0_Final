import 'package:flutter/widgets.dart';
import 'package:gasto_0/features/auth/screens/login.dart';
import 'package:gasto_0/features/gastos/screens/agregar_gasto.dart';
import 'package:gasto_0/features/gastos/screens/reporte_gasto.dart';
import 'package:gasto_0/features/gastos/screens/statistics.dart';
import 'package:gasto_0/features/home/screens/dashboard.dart';
import 'package:gasto_0/features/home/screens/confi.dart';


Map<String, WidgetBuilder> generateRoutes() {
  return {
    '/': (context) => const Dashboard(),
    '/agregar_gasto': (context) => AgregarGasto(),
    '/login': (context) => const Login(),
    '/statistics': (context) => const Statistics(),
    'reporte_gasto': (context) => const ReporteGastoScreen(),
    'configuracion': (context) => const ConfiguracionScreen(), 
  };
}
