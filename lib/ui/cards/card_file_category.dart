import 'package:flutter/material.dart';

Widget fileCategory(Icon cardIcon, EdgeInsetsGeometry cardPadding,
    String cardText, VoidCallback cardOnPressed,
    [Color? cardColor]) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: cardPadding,
        ),
        onPressed: () {
          cardOnPressed();
        },
        child: cardIcon,
      ),
      const SizedBox(height: 10),
      Text(cardText,
          style: const TextStyle(
              color: Color.fromRGBO(95, 125, 163, 1),
              fontSize: 18,
              fontWeight: FontWeight.w600))
    ],
  );
}
