import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class PDFWholeWidget extends StatefulWidget {
  const PDFWholeWidget({Key key}) : super(key: key);

  @override
  State<PDFWholeWidget> createState() => _PDFWholeWidgetState();
}

class _PDFWholeWidgetState extends BaseState<PDFWholeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: '确认书',
      ),
      body: Column(
        children: [
          Expanded(
              child: PDF.network(
            'https://www.baidu.com/img/bd_logo1.png',
            width: MediaQuery.of(context).size.width,
          )),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              color: AppTheme.textBlue,
              height: 50,
              child: Text(
                "确认签署",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
