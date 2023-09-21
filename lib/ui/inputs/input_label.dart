import 'package:flutter/material.dart';

class LabelInput extends StatelessWidget {
  const LabelInput({super.key, required this.label, required this.input});
  final String label;
  final Widget input;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 9.0),
        input,
        const SizedBox(height: 16.0)
      ],
    );
  }
}
