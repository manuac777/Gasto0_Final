import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String label;
  final bool isPassword;
  final IconData? icono;
  final TextEditingController controller;
  const Input({
    super.key,
    required this.label,
    this.isPassword = false,
    this.icono,
    required this.controller, required bool readOnly, required Future<Null> Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 200,
            child: Text(
              label,
              style: Theme.of(context).primaryTextTheme.labelMedium,
            )),
        SizedBox(
          width: 300,
          child: TextField(
            key: ValueKey(label),
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: icono != null ? Icon(icono) : null,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
