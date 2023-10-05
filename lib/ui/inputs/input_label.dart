import 'package:flutter/material.dart';

class LabelInput extends StatelessWidget {
  const LabelInput({super.key, this.label, required this.input});
  final String? label;
  final Widget input;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(60, 96, 130, 1),
            ),
          ),
        const SizedBox(height: 5.0),
        input,
      ],
    );
  }
}
