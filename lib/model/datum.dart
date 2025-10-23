/*
 * @Author: WeJeson wangshibo@gc.com
 * @Date: 2024-07-31 10:37:26
 * @LastEditors: WeJeson wangshibo@gc.com
 * @LastEditTime: 2024-07-31 11:06:48
 * @FilePath: /notarization-quzheng-flutter-noPay/lib/app/data/model/base_list_response_model/datum.dart
 * @Description: 
 * 
 * Copyright (c) 2024 by ${git_name_email}, All Rights Reserved. 
 */
import 'dart:convert';


class Datum {
  final String fileName;
  final String fileType;
  final String filePath;
  final dynamic annexType;
  final dynamic notarizationAnnexId;

  const Datum({
    this.fileName,
    this.fileType,
    this.filePath,
    this.annexType,
    this.notarizationAnnexId,
  });

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
        fileName: data['fileName'] as String,
        fileType: data['fileType'] as String,
        filePath: data['filePath'] as String,
        annexType: data['annexType'] as dynamic,
        notarizationAnnexId: data['notarizationAnnexId'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'fileName': fileName,
        'fileType': fileType,
        'filePath': filePath,
        'annexType': annexType,
        'notarizationAnnexId': notarizationAnnexId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    String fileName,
    String fileType,
    String filePath,
    dynamic annexType,
    dynamic notarizationAnnexId,
  }) {
    return Datum(
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      filePath: filePath ?? this.filePath,
      annexType: annexType ?? this.annexType,
      notarizationAnnexId: notarizationAnnexId ?? this.notarizationAnnexId,
    );
  }

}
