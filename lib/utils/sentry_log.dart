// /*
//  * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
//  * @Date: 2023-02-13 14:24:58
//  * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
//  * @LastEditTime: 2023-02-13 17:52:02
//  * @FilePath: /remouldApp/lib/utils/sentry_log.dart
//  * @Description: 报错bug收集类
//  *
//  * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
//  */
// import 'package:flutter/foundation.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
//
// class SentryLog {
//   SentryLog._();
//
//   static void init({Function initFunction}) async {
//     String dsn = '';
//     if (kDebugMode) {
//       dsn = 'http://af27c255f6994ed4bc06204f2039f09e@39.96.36.31:9000/2';
//     } else if (kReleaseMode) {
//       dsn = 'http://d39d192c3a28405a9adf1f0ca3a1dc04@39.96.36.31:9000/5';
//     }
//     await SentryFlutter.init(
//       (options) {
//         options.dsn = dsn;
//         options.useNativeBreadcrumbTracking();
//       },
//       appRunner: initFunction(),
//     );
//   }
//
//   static void catchBugLogs(exception, stackTrace, hint) async {
//     await Sentry.captureException(exception,
//         stackTrace: stackTrace, hint: hint ?? '');
//   }
//
//   static void catchBugMessage(
//     String message, {
//     SentryLevel level,
//     String template,
//     List<dynamic> params,
//     dynamic hint,
//   }) async {
//     await Sentry.captureMessage(message,
//         level: level, template: template, params: params, hint: hint);
//   }
// }
