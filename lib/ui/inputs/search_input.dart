import 'package:flutter/material.dart';
import 'package:safesync/icons/icons.dart';

// ignore: must_be_immutable
class SearchInput extends StatelessWidget {
  SearchInput({super.key, required this.controller, required this.onChanged});

  TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 250, 255, 255),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(176, 217, 255, 0.4),
            blurRadius: 15.0,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          onChanged(value);
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(SafeSyncIcons.lupa, size: 26),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(200, 235, 255, 1)),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: 'Buscar carpetas, archivos...',
            hintStyle:
                const TextStyle(color: Color.fromRGBO(176, 199, 212, 1))),
      ),
    );
  }
}
