import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObsucureText;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObsucureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsucureText,
      obscuringCharacter: '*',
      validator: (val) {
        if (val!.trim().isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
