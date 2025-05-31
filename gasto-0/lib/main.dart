import 'package:flutter/material.dart';
import 'package:gasto_0/features/auth/providers/auth_provider.dart';
import 'package:gasto_0/main_theme.dart';
import 'package:gasto_0/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainTheme,
      routes: generateRoutes(),
      initialRoute: '/',
    );
  }
}
