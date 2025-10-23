import 'package:flutter_screen_recording/flutter_screen_recording.dart';

import 'common_tools.dart';

class RecordTools{

  static RecordTools _singleton;

  factory RecordTools() => getSingleton();

  static RecordTools getSingleton() {
    if (_singleton == null) {
      _singleton = RecordTools._internal();
    }
    return _singleton;
  }

  RecordTools._internal(){

  }

  // 开始录屏
  static startRecordScreen(String fileName,Function result){
    FlutterScreenRecording.startRecordScreen(fileName).then((data){
      wjPrint("started-------$data");
      result(data);
    });
  }

  // 结束录屏
 static stopRecordScreen(Function stopResult){
    FlutterScreenRecording.stopRecordScreen.then((value){
      stopResult(value);
    });
 }
}