import 'package:flutter/material.dart';
import 'package:gasto_0/features/auth/providers/auth_provider.dart';
import 'package:gasto_0/features/auth/screens/login.dart';
import 'package:provider/provider.dart';

Widget drawerMenu(BuildContext context) {
  AuthProvider authProvider = Provider.of<AuthProvider>(context);
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Header',
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Inicio'),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.format_list_bulleted_add),
                  title: Text('Agregar Gasto'),
                  onTap: () {
                    Navigator.pushNamed(context, '/agregar_gasto');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.pending_actions_outlined),
                  title: Text('Reportes'),
                  onTap: () {
                    Navigator.pushNamed(context, 'reporte_gasto');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.stacked_line_chart_sharp),
                  title: Text('Estadisticas'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/statistics',
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuracion'),
                  onTap: () {
                    Navigator.pushNamed(context, 'configuracion');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesion'),
                  onTap: () async {
                    await authProvider.logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
