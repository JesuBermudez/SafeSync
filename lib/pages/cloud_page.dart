import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/user/user.dart';
import 'package:safesync/ui/containers/pages_container.dart';
import 'package:safesync/ui/labels/title_label.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';

// ignore: must_be_immutable
class CloudPage extends StatelessWidget {
  CloudPage({super.key});

  User user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          PagesContainer(
              content: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              titleLabel("Almacenamiento", fontSize: 25),
              Stack(alignment: Alignment.center, children: [
                AnimatedCircularChart(
                  size: const Size(300, 300),
                  initialChartData: <CircularStackEntry>[
                    CircularStackEntry(
                      <CircularSegmentEntry>[
                        CircularSegmentEntry(
                          user.space.value.toDouble(),
                          const Color.fromRGBO(28, 123, 255, 1),
                          rankKey: 'completed',
                        ),
                        CircularSegmentEntry(
                          (5000000000 - user.space.value).toDouble(),
                          const Color.fromRGBO(225, 243, 253, 1),
                          rankKey: 'remaining',
                        ),
                      ],
                      rankKey: 'progress',
                    ),
                  ],
                  chartType: CircularChartType.Radial,
                  edgeStyle: SegmentEdgeStyle.round,
                ),
                Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(color: Colors.blueGrey.shade50, blurRadius: 7)
                      ]),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: formatSize(user.space.value.toDouble())
                              .split(" ")[0],
                          style: const TextStyle(
                              fontSize: 55,
                              color: Color.fromRGBO(49, 48, 102, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              ' ${formatSize(user.space.value.toDouble()).split(" ")[1]}\n',
                          style: const TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(116, 117, 155, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: 'espacio usado',
                          style: TextStyle(
                              fontSize: 19,
                              color: Color.fromRGBO(116, 117, 155, 1),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'Total\n',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(71, 96, 129, 1))),
                      TextSpan(
                          text: '5 GB',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(15, 58, 115, 1)))
                    ])),
                const SizedBox(
                  width: 90,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                          text: 'Disponible\n',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(71, 96, 129, 1))),
                      TextSpan(
                          text: formatSize(
                              (5000000000 - user.space.value).toDouble()),
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(15, 58, 115, 1)))
                    ]))
              ]),
              const SizedBox(height: 30),
              ...calculateSpaceAndFileCount().map((data) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.shade200,
                                blurRadius: 10,
                                offset: const Offset(3, 3))
                          ]),
                      padding: const EdgeInsets.all(10),
                      height: 70,
                      width: Get.width >= 330
                          ? 320
                          : Get.width - (Get.width * 0.08),
                      child: Row(children: [
                        Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: fileType[data['type']]['Color'],
                                borderRadius: BorderRadius.circular(5)),
                            child: fileType[data['type']]['Icon']),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['type']!,
                                    style: const TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(55, 81, 115, 1))),
                                Expanded(
                                  child: Row(children: [
                                    Text(data['size']!,
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                102, 135, 178, 1))),
                                    const Spacer(),
                                    Text("${data['count']} archivos",
                                        style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                102, 135, 178, 1)))
                                  ]),
                                ),
                                Stack(children: [
                                  Container(
                                      height: 10,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(200, 211, 225, 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  FractionallySizedBox(
                                    widthFactor: double.parse(data["bytes"]!) /
                                        user.space.value,
                                    child: Container(
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: fileType[data['type']][
                                            'Color'], // Cambia esto al color que desees
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                  )
                                ])
                              ]),
                        )
                      ]),
                    ),
                    const SizedBox(height: 15)
                  ],
                );
              })
            ],
          ))
        ],
      );
    });
  }

  Map<String, dynamic> fileType = {
    'Imagenes': {
      'Color': const Color.fromRGBO(222, 94, 221, 1),
      'Icon': const Icon(Icons.image_rounded, color: Colors.white, size: 30)
    },
    'Videos': {
      'Color': Colors.cyan.shade300,
      'Icon':
          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30)
    },
    'Documentos': {
      'Color': const Color.fromRGBO(92, 223, 129, 1),
      'Icon': const Icon(Icons.insert_drive_file_rounded,
          color: Colors.white, size: 30)
    }
  };

  List<Map<String, String>> calculateSpaceAndFileCount() {
    int imageCount = 0;
    double imageSize = 0;
    int videoCount = 0;
    double videoSize = 0;
    int docCount = 0;
    double docSize = 0;

    for (var directory in user.directories) {
      for (var file in directory.files) {
        if (_isImageFile(file.nameFile)) {
          imageCount++;
          imageSize += file.size;
        } else if (_isVideoFile(file.nameFile)) {
          videoCount++;
          videoSize += file.size;
        } else {
          docCount++;
          docSize += file.size;
        }
      }
    }

    return [
      {
        'type': "Imagenes",
        'count': imageCount.toString(),
        'size': formatSize(imageSize).toString(),
        'bytes': imageCount.toString()
      },
      {
        'type': "Videos",
        'count': videoCount.toString(),
        'size': formatSize(videoSize).toString(),
        'bytes': videoSize.toString()
      },
      {
        'type': "Documentos",
        'count': docCount.toString(),
        'size': formatSize(docSize).toString(),
        'bytes': docSize.toString()
      }
    ];
  }
}

String formatSize(double sizeInBytes) {
  if (sizeInBytes < 1000) {
    return sizeInBytes < 100
        ? '${sizeInBytes.toStringAsFixed(1)} b'
        : '${(sizeInBytes / 1000).toStringAsFixed(1)} KB';
  } else if (sizeInBytes < 1000 * 1000) {
    double sizeInKb = sizeInBytes / 1000;
    return sizeInKb < 100
        ? '${sizeInKb.toStringAsFixed(1)} KB'
        : '${(sizeInKb / 1000).toStringAsFixed(1)} MB';
  } else if (sizeInBytes < 1000 * 1000 * 1000) {
    double sizeInMb = sizeInBytes / (1000 * 1000);
    return sizeInMb < 100
        ? '${sizeInMb.toStringAsFixed(1)} MB'
        : '${(sizeInMb / 1000).toStringAsFixed(1)} GB';
  } else if (sizeInBytes < 1000 * 1000 * 1000 * 1000) {
    double sizeInGb = sizeInBytes / (1000 * 1000 * 1000);
    return sizeInGb < 100
        ? '${sizeInGb.toStringAsFixed(1)} GB'
        : '${(sizeInGb / 1000).toStringAsFixed(1)} TB';
  } else {
    double sizeInTb = sizeInBytes / (1000 * 1000 * 1000 * 1000);
    return '${sizeInTb.toStringAsFixed(1)} TB';
  }
}

bool _isImageFile(String fileName) {
  final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp', 'svg'];
  final lowerCaseFileName = fileName.toLowerCase();
  return imageExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}

bool _isVideoFile(String fileName) {
  final videoExtensions = ['.mp4', '.avi', '.mkv', '.flv', '.wmv', 'webm'];
  final lowerCaseFileName = fileName.toLowerCase();
  return videoExtensions.any((ext) => lowerCaseFileName.endsWith(ext));
}
