import 'package:flutter/material.dart';
import 'package:safesync/services/file/file.dart';
import 'package:share_plus/share_plus.dart';

Widget recentFiles(
    {Icon? iconCard,
    Image? imageCard,
    String? titleCard,
    String? dateCard,
    String? weightCard,
    String? folderName,
    Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 150,
      height: 170,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: Color.fromARGB(90, 13, 72, 161),
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
                        height: 84,
                        margin: const EdgeInsets.only(bottom: 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: imageCard,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: (iconCard ??
                            const Icon(Icons.question_mark_rounded, size: 84)),
                      ),
                Container(
                  alignment: Alignment.center,
                  width: 130,
                  child: Column(
                    children: [
                      Text(
                        '$titleCard',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Color.fromRGBO(55, 81, 115, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      buildVariableText('$dateCard', '$weightCard'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -2,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_horiz,
                  color: Color.fromRGBO(54, 93, 125, 1),
                ),
                onSelected: (String result) async {
                  if (result == 'Compartir link') {
                    String path = await shareFile('$titleCard', '$folderName');
                    if (path.isNotEmpty) {
                      Share.share(
                          'SafeSync App\n\nTe comparto mi archivo:\nlink: $titleCard $path');
                    }
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'Abrir con', child: Text('Abrir con')),
                  const PopupMenuItem<String>(
                      value: 'Compartir link', child: Text('Compartir link')),
                  const PopupMenuItem(value: 'QR', child: Text('Mostrar QR')),
                  const PopupMenuItem<String>(
                      value: 'Borrar', child: Text('Borrar')),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildVariableText(String text1, String text2) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      const style = TextStyle(
          color: Color.fromRGBO(88, 115, 150, 0.8),
          fontSize: 12,
          fontWeight: FontWeight.w600);
      final span1 = TextSpan(text: text1, style: style);
      final span2 = TextSpan(text: text2, style: style);
      const dash = TextSpan(text: ' - ', style: style);

      final tp1 = TextPainter(text: span1, textDirection: TextDirection.ltr);
      tp1.layout();
      final tp2 = TextPainter(text: span2, textDirection: TextDirection.ltr);
      tp2.layout();
      final tpDash = TextPainter(text: dash, textDirection: TextDirection.ltr);
      tpDash.layout();

      if (tp1.width + tpDash.width + tp2.width <= constraints.maxWidth) {
        // Si las dos variables y el guión caben en una línea
        return Text.rich(
          TextSpan(
            children: [span1, dash, span2],
            style: style,
          ),
        );
      } else {
        // Si no caben en una línea
        return Column(
          children: [
            Text(text1, style: style),
            Text(text2, style: style),
          ],
        );
      }
    },
  );
}
