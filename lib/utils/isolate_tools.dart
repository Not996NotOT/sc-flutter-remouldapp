import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'common_tools.dart';

class IsoLateTools {
  // 文件写入
  writeDataToFilePath(
      {Map<String, dynamic> data, Function callBack}) async {
    final ReceivePort receivePort = ReceivePort();
    Isolate isolate;
    isolate = await Isolate.spawn(writeDataToFile, receivePort.sendPort);
    final SendPort sendPort = await receivePort.first as SendPort;
    final msg = await sendReceive(
      sendPort,
      data,
    );
    receivePort.close();
    isolate.kill();
    if (callBack != null) {
      callBack(msg);
    }
  }

  static Future<void> writeDataToFile(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    final ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);
    await for (final dynamic msg in port) {
      final Map<String, dynamic> data = msg[0] as Map<String, dynamic>;
      // final SendPort replyTo = msg[1] as SendPort;
      // Map<String, dynamic> valueMap = {};
      try {
        File file = File(data['path']);
        // file.createSync();
        file.writeAsStringSync(data["content"], mode: FileMode.append);
        wjPrint("文件写入成功");
      } catch (e) {
        wjPrint("写入文件时报错：$e");
      }
      port.close();
    }
  }

  Future<dynamic> sendReceive(SendPort port, Map<String, dynamic> data) {
    final ReceivePort response = ReceivePort();
    port.send(<dynamic>[data, response.sendPort]);
    return response.first;
  }
}
