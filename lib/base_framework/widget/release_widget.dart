import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/common_tools.dart';
import 'entity/release_model.dart';

class ReleaseWidget extends StatefulWidget {
  final ReleaseCon con;
  final String hint;
  final int minLines;
  final bool showInput;
  final ReleaseImgCallback callback;
  final DeleteImgCallback deleteImgCallback;
  final ReleaseAssetCallback assetCallback;
  final bool isEdit;

  const ReleaseWidget(
      {Key key,
      this.con,
      this.hint,
      this.minLines = 4,
      this.showInput = false,
      this.callback,
      this.deleteImgCallback,
      this.assetCallback,
      this.isEdit = true})
      : super(key: key);

  @override
  _ReleaseWidgetState createState() => _ReleaseWidgetState(con);
}

class ReleaseCon {
  List<ReleaseModel> releaseList = [];

  List<ReleaseModel> getReleaseList() {
    return releaseList;
  }

  void setReleaseList(List<ReleaseModel> releaseList) {
    this.releaseList = releaseList;
  }
}

class _ReleaseWidgetState extends State<ReleaseWidget> {
  List<ReleaseModel> releaseList = [];
  List<Asset> tempImageList = [];
  final ReleaseCon con;
  int beforeCount = 0;

  _ReleaseWidgetState(this.con);

  @override
  void initState() {
    super.initState();
    if (con.releaseList.isNotEmpty) {
      releaseList.addAll(con.releaseList);
      beforeCount = con.releaseList[0].imageList.length;
    } else {
      releaseList.add(new ReleaseModel("", new List(), new List()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
            itemCount: releaseList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (c, index) {
              return releaseWidget(index);
            }),
//        InkWell(
//          onTap: () {
//            setState(() {
//              releaseList.add(new ReleaseModel("", new List()));
//              con.setReleaseList(releaseList);
//            });
//          },
//          child: Column(
//            children: <Widget>[
//              Icon(Icons.add_circle_outline, color: Colors.black26, size: 60),
//              Text(
//                "分段添加图文",
//                style: TextStyle(color: Colors.black26, fontSize: 12),
//              )
//            ],
//          ),
//        )
      ],
    );
  }

  Widget releaseWidget(int pIndex) {
    ReleaseModel model = releaseList[pIndex];
    List images = model.imageList;
    wjPrint("图片数量${images.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Offstage(
          offstage: pIndex == 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (releaseList.length > 1) {
                    releaseList.removeAt(pIndex);
                    con.setReleaseList(releaseList);
                  }
                });
              },
              child: Icon(
                Icons.cancel,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ),
//        Offstage(
//          offstage: widget.showInput,
//          child: Container(
//            child: Padding(
//              padding: const EdgeInsets.only(left: 10, right: 10),
//              child: TextField(
//                  maxLines: 10,
//                  minLines: minLines,
//                  maxLength: 140,
//                  style: TextStyle(fontSize: 14),
//                  decoration: InputDecoration(
//                    hintText: hint,
//                    hintStyle: TextStyle(fontSize: 14),
//                    border: InputBorder.none,
//                  ),
//                  inputFormatters: [
//                    BlacklistingTextInputFormatter(RegExp(
//                        "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
//                  ],
//                  onChanged: (v) {
//                    var reg = RegExp(
//                        "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]");
//                    if (!reg.hasMatch(v) &&
//                        releaseList[pIndex].content.length <= 139) {
//                      releaseList[pIndex].content = v;
//                    }
////                  releaseList[pIndex].content=v;
//                    con.setReleaseList(releaseList);
//                  }),
//            ),
//          ),
//        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: images.length == 9 ? 9 : images.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                if (index != 9) {
                  return releaseImage(
                      pIndex,
                      index,
                      index == images.length && index != 9,
                      index != images.length ? images[index] : null);
                } else {
                  return null;
                }
              }),
        ),
      ],
    );
  }

  Widget releaseImage(int pIndex, int cIndex, bool isDef, var asset) {
    wjPrint("$pIndex+$isDef");
    return isDef
        ? widget.isEdit
            ? InkWell(
                onTap: () {
                  requestCameraPermission(pIndex);
                },
                child: Image.asset("lib/assets/images/add_img.png"))
            : Container()
        : Stack(children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: asset is Asset
                  ? AssetThumb(
                      asset: asset,
                      width: 500,
                      height: 500,
                    )
                  : asset.contains('http')
                      ? Image.network(asset,
                          width: 500, height: 500, fit: BoxFit.cover)
                      : Offstage(offstage: true, child: Container()),
            ),
            widget.isEdit && !asset.toString().contains('http')
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            releaseList[pIndex].imageList.removeAt(cIndex);
                            releaseList[pIndex]
                                .fileList
                                .removeAt(cIndex - beforeCount);
                            con.setReleaseList(releaseList);
                            if (widget.deleteImgCallback != null) {
                              widget.deleteImgCallback
                                  .call(cIndex - beforeCount);
                            }
                          });
                        },
                        child: Icon(Icons.clear, color: Colors.redAccent)))
                : SizedBox(width: 0, height: 0)
          ]);
  }

  Future<void> requestCameraPermission(int pIndex) async {
    if(Platform.isAndroid){
      if(!await Permission.storage.status.isGranted || !await Permission.camera.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2
        );
      }
      if (await Permission.storage.request().isGranted &&
          await Permission.camera.request().isGranted){
        selectAssets(pIndex);
      }else{
        G.showPermissionDialog(str: "访问内部相机、相册及文件权限");
      }
    }
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted && await Permission.camera.request().isGranted){
        selectAssets(pIndex);
      }else{
        G.showPermissionDialog(str: "访问相机、相册权限");
      }
    }

  }

//选照片
  Future<void> selectAssets(int pIndex) async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 9 - releaseList[pIndex].imageList.length,
        // maxImages:1,
        // 是否支持拍照
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarTitle: "相册图片",
          allViewTitle: "所有图片",
          actionBarColor: "#1E90FF",
          actionBarTitleColor: "#FFFFFF",
          statusBarColor: '#1E90FF',
          startInAllView: true,
          useDetailsView: true,
          selectCircleStrokeColor: "#FFFFFF",
          selectionLimitReachedText: "您最多只能选择这些",
          textOnNothingSelected: "没有选择照片",
        ),
      );
      if (resultList != null && resultList.length != 0) {
        EasyLoading.show(status: "上传图片...");
        for (int i = 0; i < resultList.length; i++) {
          Asset asset = resultList[i];
          if (asset.originalHeight <= 0 || asset.originalWidth <= 0) {
            EasyLoading.dismiss();
            ToastUtil.showErrorToast("文件已破损，请重新选择");
          } else {
            ByteData oldBd = await asset.getByteData();
            List<int> imageData = oldBd.buffer.asUint8List();
            List<int> result = await FlutterImageCompress.compressWithList(
              imageData,
              minWidth: 2300, //压缩后的最小宽度
              minHeight: 1500, //压缩后的最小高度
              quality: 20, //压缩质量
              rotate: 0, //旋转角度
            );
            MultipartFile multipartFile = MultipartFile.fromBytes(
              result,
              filename: '${currentTimeMillis()}.jpg',
              contentType: MediaType("image", "jpg"),
            );

            wjPrint('0000000');
            if (widget.assetCallback != null) {
              wjPrint('111111');
              widget.assetCallback.call(multipartFile, asset, (value) {
                if (value) {
                  EasyLoading.show(status: '该文件已上传，请勿重复上传！');
                  // sleep(const Duration(seconds: 2));
                  // EasyLoading.dismiss();
                  Future.delayed(const Duration(seconds: 2), () {
                    EasyLoading.dismiss();
                  });
                } else {
                  wjPrint('222222');
                  if (i + 1 == resultList.length) {
                    wjPrint('333333');
                    EasyLoading.dismiss();
                  }
                  setState(() {
                    releaseList[pIndex].imageList.add(asset);
                    releaseList[pIndex].fileList.add(multipartFile);
                    con.setReleaseList(releaseList);
                  });
                }
              });
            } else {
              wjPrint('444444');
              if (widget.callback != null) {
                wjPrint('555555');
                widget.callback.call(multipartFile);
                wjPrint('66666666');
                if (i + 1 == resultList.length) {
                  EasyLoading.dismiss();
                }
              }
              setState(() {
                releaseList[pIndex].imageList.add(resultList[i]);
                releaseList[pIndex].fileList.add(multipartFile);
                con.setReleaseList(releaseList);
              });
            }
          }
        }
      }
    } on Exception catch (e) {
      print('e----${e.toString()}');
    }
  }

  // Future<MultipartFile> imageCompressAndGetFile(int index, Asset file) async {
  //   // 获取 ByteData
  //   ByteData oldBd = await file.getByteData();
  //   List<int> imageData = oldBd.buffer.asUint8List();
  //   debugPrint("压缩前：${imageData.length / 1024}");
  //
  //   var quality = 100;
  //   if (imageData.length > 8 * 1024 * 1024) {
  //     quality = 20;
  //   } else if (imageData.length > 4 * 1024 * 1024) {
  //     quality = 50;
  //   } else if (imageData.length > 2 * 1024 * 1024) {
  //     quality = 60;
  //   } else if (imageData.length > 1 * 1024 * 1024) {
  //     quality = 70;
  //   } else if (imageData.length > 0.5 * 1024 * 1024) {
  //     quality = 80;
  //   } else if (imageData.length > 0.25 * 1024 * 1024) {
  //     quality = 90;
  //   }
  //   ByteData byteData = await file.getByteData(quality: quality);
  //   List<int> newImage = byteData.buffer.asUint8List();
  //   debugPrint("压缩后：${newImage.length / 1024}");
  //   MultipartFile multipartFile = MultipartFile.fromBytes(
  //     newImage,
  //     filename: '${currentTimeMillis()}.jpg',
  //     contentType: MediaType("image", "jpg"),
  //   );
  //   debugPrint("添加图片MediaType");
  //   return multipartFile;
  // }
  int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }
}

typedef ReleaseImgCallback(MultipartFile a);

typedef ReleaseAssetCallback(MultipartFile a, Asset b, Function callBack);

typedef DeleteImgCallback(int index);
