import 'package:flutter/material.dart';

Widget recentFiles(
    {Icon? iconCard, Image? imageCard, String? titleCard, String? fileWeight}) {
  return Container(
    width: 150,
    height: 170,
    decoration: BoxDecoration(boxShadow: const [
      BoxShadow(
          color: Color.fromARGB(125, 13, 72, 161),
          offset: Offset(2, 2),
          blurRadius: 7)
    ], borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // se muestra la imagen spoiler, sino, el icono de documento, y sino, un icono por defecto
              imageCard != null
                  ? Container(
                      width: 130.0,
                      height: 69,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: imageCard,
                    )
                  : (iconCard ??
                      const Icon(Icons.question_mark_rounded, size: 84)),
              Container(
                alignment: Alignment.center,
                width: 130,
                child: Text(
                  '$titleCard',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Color.fromRGBO(55, 81, 115, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '$fileWeight',
                style: const TextStyle(
                    color: Color.fromRGBO(88, 115, 150, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Positioned(
          top: -2,
          right: 0,
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.more_horiz,
              color: Color.fromRGBO(54, 93, 125, 1),
            ), // Este es el ícono de los 3 puntos
            onSelected: (String result) {
              // Aquí puedes manejar la opción seleccionada
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Abrir con',
                child: Text('Abrir con'),
              ),
              const PopupMenuItem<String>(
                value: 'Compartir',
                child: Text('Compartir'),
              ),
              const PopupMenuItem<String>(
                value: 'Borrar',
                child: Text('Borrar'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
