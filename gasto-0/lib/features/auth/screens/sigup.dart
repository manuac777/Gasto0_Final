import 'package:flutter/material.dart';
import 'package:gasto_0/Models/user.dart';
import 'package:gasto_0/core/services/auth_service.dart';
import 'package:gasto_0/features/auth/widgets/input_login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register(context) async {
    setState(() => _isLoading = true);

    User user = User.withoutID(
        nombreController.text,
        int.parse(edadController.text),
        correoController.text,
        passwordController.text);

    final response = await AuthService.registerUser(user);
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado')),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 50,
          children: [
            Text(
              'Registrate',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Inputlogin(label: 'Nombre', controller: nombreController),
                Inputlogin(label: 'Edad', controller: edadController),
                Inputlogin(label: 'Correo', controller: correoController),
                Inputlogin(
                  label: 'Contraseña',
                  controller: passwordController,
                  isPassword: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    _register(context);
                  },
                  child: Text('Registrarse'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ya tienes cuenta? '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Inicia sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
