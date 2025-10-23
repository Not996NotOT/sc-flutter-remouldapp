/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-23 14:28:52
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-12-11 18:41:40
 * @FilePath: /remouldApp/lib/page/home/case_detail.dart
 * @Description: 案件详情
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'dart:async';
import 'dart:io';

import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/fade_route.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_gallery.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/model/judicial_expertise_list_data_model.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../../base_framework/utils/toast_util.dart';
import '../../service_api/home_api.dart';
import '../../utils/common_tools.dart';
import 'vm/case_detail_view_model.dart';

class CaseDetail extends StatefulWidget {
  final Records records;

  const CaseDetail({Key key, this.records}) : super(key: key);

  @override
  State<CaseDetail> createState() => _CaseDetailState();
}

class _CaseDetailState extends State<CaseDetail> {
  String fileUrl = '';

  List imageData = [];

  // 获取文件信息
  getFileInformation() {
    EasyLoading.show(status: "正在获取文书信息");
    HomeApi.getSingleton().queryFileById(widget.records.notificationFileId,
        errorCallBack: (error) {
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("获取文书信息失败！");
    }).then((value) async {
      if (value != null && value['code'] == 200 && value['data'] != null) {
        // "https://testgz.njguochu.com:33133/group1/M00/1E/03/wKgx4WVEifyAY5uVADFE8tF74FA094.pdf";//
        Completer<File> completer = Completer();
        wjPrint("Start download file from internet!");
        try {
          // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
          // final url = "https://pdfkit.org/docs/guide.pdf";
          String url = value['data']['filePath'];
          pdfToImage(url);
          // final filename = url.substring(url.lastIndexOf("/") + 1);
          // var request = await HttpClient().getUrl(Uri.parse(url));
          // var response = await request.close();
          // var bytes = await consolidateHttpClientResponseBytes(response);
          // var dir = await getApplicationDocumentsDirectory();
          // wjPrint("Download files");
          // wjPrint("${dir.path}/$filename");
          // File file = File("${dir.path}/$filename");
          //
          // await file.writeAsBytes(bytes, flush: true);
          // completer.complete(file);
          // setState(() {
          //   fileUrl = file.path;
          // });
        } catch (e) {
          EasyLoading.dismiss();
          throw Exception('Error parsing asset file!');
        }

        return completer.future;
      } else {
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("获取文书信息失败！");
      }
    });
  }

  /// pdf 转图片

  void pdfToImage(String url) {
    HomeApi.getSingleton().pdfToImg({
      'filePath': url,
    }, errorCallBack: (error) {
      EasyLoading.dismiss();
    }).then((value) {
      if (value != null) {
        if (value['code'] == 200) {
          EasyLoading.dismiss();
          if (value['data'] != null && value['data'].toString().isNotEmpty) {
            setState(() {
              imageData.addAll(value['data']);
            });
          } else {
            ToastUtil.showToast("暂时无法获取文件信息");
          }
        } else {
          EasyLoading.dismiss();
          ToastUtil.showToast("暂时无法获取文件信息");
        }
      } else {
        EasyLoading.dismiss();
        ToastUtil.showToast("网络出错了，请稍后再试");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFileInformation();
    if (widget.records.accepanceFileId != null &&
        widget.records.accepanceFileId.toString().isNotEmpty) {
      pdfToImage(widget.records.accepanceFileId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("案件详情", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              G.pop();
            },
          ),
        ),
        body: ProviderWidget<CaseDetailViewModel>(
          model: CaseDetailViewModel(),
          onModelReady: (model) {
            model.loadData();
          },
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                notaryTextWidget,
                caseInformationWidget,
                lotteryResultWidget,
                notarialDocumentWidget,
              ],
            ));
          },
        ));
  }

  // 公证处展示
  Widget get notaryTextWidget => Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Center(
            child: Text(
          '本案件由${widget.records.notaryName ?? "南京市石城公证处"}进行公证',
          maxLines: 4,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF333333)),
        )),
      );

  // 案件信息
  Widget get caseInformationWidget => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: AppTheme.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/assets/images/icon_case_information.png",
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: Text(
                    '案件信息',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Divider(),
            rowItemWidget('车牌号', "${widget.records.caseNumber ?? ''}", null),
            rowItemWidget(
                "受理时间", dealTimeString(widget.records.acceptanceDate), null),
            rowItemWidget(
                '摇号人',
                "${widget.records.whetherDelegate == 1 ? widget.records.principalName : widget.records.name ?? ''}",
                null),
            rowItemWidget(
                '身份证号',
                "${widget.records.whetherDelegate == 1 ? widget.records.principalIdCard : widget.records.idCard ?? ''}",
                null),
            widget.records.whetherDelegate == 1
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      rowItemWidget(
                          '被鉴定人', "${widget.records.name ?? ''}", null),
                      rowItemWidget(
                          '身份证号', "${widget.records.idCard ?? ''}", null),
                    ],
                  )
                : const SizedBox(),
            rowItemWidget(
                '摇号创建时间', dealTimeString(widget.records.createDate), null),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Text(
                      "发票下载",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        if (!await Permission.storage.status.isGranted) {
                          G.showCustomToast(
                            context: G.getCurrentState().overlay.context,
                            titleText: "文件存储权限使用说明：",
                            subTitleText: "用于文件存储等场景",
                            time: 2,
                          );
                        }
                        if (await Permission.storage.request().isGranted) {
                          downloadFile(widget.records.invoiceFileUrl);
                        } else {
                          G.showPermissionDialog(str: '访问内部存储权限');
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "下载",
                          maxLines: 3,
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF333333)),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      );

  /// 文件下载
  void downloadFile(String url) async {
    try {
      var dir;
      String dirPath;
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
        dirPath = dir.path;
      } else if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
        dirPath = dir.path;
      }
      Directory directory = Directory("$dirPath/downloads");
      if (url == null) {
        return ToastUtil.showErrorToast("链接地址为空");
      }
      if (!directory.existsSync()) {
        directory.createSync();
      }
      String savePath = "${directory.path}/${url.split("/").last}";
      Response response = await Dio().download(url, savePath);
      wjPrint("savePath---------$savePath");
      if (response.statusCode == 200) {
        if (Platform.isIOS) {
           ToastUtil.showSuccessToast("文件下载成功！请前往：文件/我的iPhone/青桐智盒/downloads 中查看");
        } else if (Platform.isAndroid){
          ToastUtil.showSuccessToast("文件下载成功!,请前往：文件管理/手机/android/data/com.njguochu.qingtongzhihe/files/downloads 中查看");
        }
       
      } else {
        ToastUtil.showErrorToast("文件下载失败！");
      }
    } catch (error) {
      ToastUtil.showErrorToast("文件下载失败！");
    }
  }

// row item widget
  Widget rowItemWidget(String title, String subTitle, Function onclick) =>
      Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                title ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: InkWell(
                onTap: onclick,
                child: Container(
                  padding: onclick == null
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: onclick == null
                      ? null
                      : BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                  child: Text(
                    subTitle ?? '',
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                  ),
                ),
              ))
            ],
          ));

  // 摇号结果
  Widget get lotteryResultWidget => Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: AppTheme.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/assets/images/icon_lottery_result.png",
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: Text(
                    '摇号结果',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '司法鉴定机构',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFEDF4FF)),
              child: Text(
                '${widget.records.appraisalNotaritionName ?? ''}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );

  // 公证文书
  Widget get notarialDocumentWidget => Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: AppTheme.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/assets/images/icon_notarial _document.png",
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: Text(
                    '公证文书',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Divider(),
            imageData.isNotEmpty
                ? GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: imageData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      //控制表格左右的距离
                      mainAxisSpacing: 10,
                      //控制表格上下的距离
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 4,
                      //列数
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          wjPrint("--------");
                          Navigator.of(context).push(FadeRoute(
                              page: PhotoViewGalleryScreen(
                                  images: imageData, //传入图片list
                                  index: index,
                                  isBase64: false,
                                  onTop: () {
                                    G.pop();
                                  },
                                  onWillPop: () {
                                    G.pop();
                                  }, //传入当前点击的图片的index
                                  heroTag: "1")));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.network(imageData[index]),
                        ),
                      );
                    })
                : const SizedBox.shrink(),
          ],
        ),
      );

  String dealTimeString(String time) {
    if (time == null) {
      return '';
    }
    if (time != null && time.length > 10) {
      return time.substring(0, 10);
    }
    return time;
  }
}
