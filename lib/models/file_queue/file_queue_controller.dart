import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesync/models/file_queue/queued_file.dart';

class FileQueueController extends GetxController {
  var queue = <QueuedFile>[].obs;
  var showList = false.obs;

  void addToQueue(QueuedFile file) {
    queue.add(file);
  }

  void removeFromQueue(QueuedFile file) {
    queue.remove(file);
  }

  Widget queueCard() {
    if (queue.isEmpty) {
      return const SizedBox();
    }

    return Positioned(
      top: 5,
      right: 5,
      child: InkWell(
        // toggle the view
        onTap: () => showList.toggle(),
        child: Container(
            width: 70,
            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1, 1),
                      blurRadius: 3)
                ]),
            // content
            child: Column(
              children: [
                // tittle
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      color: Colors.blue,
                      size: 22,
                    ),
                    const SizedBox(width: 5),
                    Text(
                        '${queue.length} ${queue.length != 1 ? 'archivos' : 'archivo'} en cola',
                        style: const TextStyle(fontSize: 14))
                  ],
                ),

                // queue list
                if (showList.value) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      QueuedFile file = queue[index];
                      return ListTile(
                        leading: file.icon,
                        title: Text(file.name)
                      );
                    },
                  )
                ]
              ],
            )),
      ),
    );
  }
}
