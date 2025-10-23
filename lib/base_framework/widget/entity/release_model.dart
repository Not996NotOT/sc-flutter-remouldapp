import 'package:dio/dio.dart';

class ReleaseModel {
  String content;
  List imageList;

  List<MultipartFile> fileList;

  ReleaseModel(this.content, this.imageList, this.fileList);
}
