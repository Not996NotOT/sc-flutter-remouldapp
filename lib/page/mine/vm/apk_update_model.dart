import 'package:flutter/cupertino.dart';

import '../../../utils/common_tools.dart';

class ApkUpdateModel with ChangeNotifier {
  int _progress = 0;

  double _uploadFile = 0;

  int get value => _progress;

  double get uploadFile => _uploadFile;

  void setTotal(int progress) {
    wjPrint("传入当前进度$progress");
    _progress = progress;
    notifyListeners();
  }

  void setUploadFile(double progress) {
    wjPrint("传入当前进度$progress");
    _uploadFile = progress;
    notifyListeners();
  }
}
