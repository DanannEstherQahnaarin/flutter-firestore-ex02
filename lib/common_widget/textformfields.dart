// lib/widgets/custom_input_field.dart

import 'package:flutter/material.dart';

class CustomInputFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // 외부에서 validator 로직을 주입받음

  const CustomInputFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    this.expands = false,
    this.hintText = '',
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      expands: expands,
      textAlignVertical:TextAlignVertical.top,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      // validator를 외부에서 주입받거나, 내부에서 기본 로직을 설정할 수 있습니다.
      validator: validator,
    ),
  );
}
