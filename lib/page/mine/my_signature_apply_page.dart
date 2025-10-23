import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/vm/my_signature_apply_viewModel.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'entity/signature_entity.dart';
import 'entity/upload_img_entity.dart';

class MySignatureApplyPage extends StatefulWidget {
  final bool isUpdate;
  final SignatureEntity entity;
  const MySignatureApplyPage({Key key,this.isUpdate,this.entity}) : super(key: key);

  @override
  State<MySignatureApplyPage> createState() => _MySignatureApplyPageState();
}

class _MySignatureApplyPageState extends BaseState<MySignatureApplyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orgCodeController = TextEditingController();
  MySignatureApplyViewModel _viewModel;

  UserInfoEntity _userInfoEntity;

  // 模拟图片数据
  String businessImg;
  String sealImg;
  String idFrontImg;
  String idBackImg;

  // 选择图片
  _showDialog(String fileType) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  getGallery(fileType);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "从相册选择图片",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  getImage(fileType);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "拍照",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "取消",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future getImage(String fileType) async {
    if(Platform.isIOS){
      if (await Permission.camera.request().isGranted) {
        final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
        wjPrint(pickedFile.path);
        if (pickedFile.path != null) {
          uploadPictures(pickedFile.path,fileType);
        }
      } else {
        G.showPermissionDialog(str: "访问相机权限");
      }
    }
    if(Platform.isAndroid){
      if(!await Permission.camera.status.isGranted || !await Permission.storage.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2
        );
      }
      if (await Permission.camera.request().isGranted &&
          await Permission.storage.request().isGranted) {
        final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
        wjPrint(pickedFile.path);
        if (pickedFile.path != null) {
         uploadPictures(pickedFile.path,fileType);
        }
      } else {
        G.showPermissionDialog(str: "访问内部存储、相机权限");
      }
    }


  }

  Future getGallery(String fileType) async {
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted){
        File pickedGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        wjPrint("11111$pickedGallery");
        if (pickedGallery.path != null) {
          wjPrint(pickedGallery.path);
          uploadPictures(pickedGallery.path,fileType);
        }
      }else{
        G.showPermissionDialog(str: "访问相册权限");
      }
    }
    if(Platform.isAndroid){
      if( !await Permission.storage.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "照片及文件权限使用说明：",
            subTitleText: "用于上传照片和文件、以及设置头像等场景",
            time: 2
        );
      }
      if(await Permission.storage.request().isGranted){
        File pickedGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        wjPrint("11111$pickedGallery");
        if (pickedGallery.path != null) {
          wjPrint(pickedGallery.path);
          uploadPictures(pickedGallery.path,fileType);
        }
      }else{
        G.showPermissionDialog(str: "访问内部照片及文件权限");
      }
    }

  }


  uploadPictures(String path,String fileType) {
    EasyLoading.show(status: "上传图片");
    MineApi.getSingleton().uploadPictures(path).then((value) {
      wjPrint("带着自理$value");
      UploadImgEntity entity = JsonConvert.fromJsonAsT(value);
      EasyLoading.dismiss();
      if (entity.code == 200) {
        setState(() {
          if(fileType == "idFrontImg"){
            idFrontImg = entity.item.filePath;
          } else if(fileType == "idBackImg"){
            idBackImg = entity.item.filePath;
          } else if(fileType == "sealImg"){
            sealImg = entity.item.filePath;
          } else if(fileType == "businessImg"){
            businessImg = entity.item.filePath;
          }
        });
        ToastUtil.showSuccessToast("图片上传成功！");
      } else {
        ToastUtil.showErrorToast("图片上传失败！");
      }
    });
  }

  Widget _buildRoleSelector() {
    return InkWell(
      onTap: () {
        // showRoleDialog();
        return PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('代理人'),
                value: _viewModel.role,
              ),
              PopupMenuItem(
                child: Text('法人'),
                value: _viewModel.role,
              ),
            ];
          },
          onSelected: (value) {
            setState(() {
              _viewModel.role = value;
            });
          },
          child: Text('请选择角色'),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 30),
        child: Row(
          children: [
            Text('角色', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            Spacer(),
            _buildRoleButton(),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildRoleButton() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text('法人'),
            value: '法人',
          ),
          PopupMenuItem(
            child: Text('代理人'),
            value: '代理人',
          ),
        ];
      },
      onSelected: (value) {
        setState(() {
          _viewModel.role = value == '法人' ? true : false;
        });
      },
      tooltip: "切换角色",
      child: Row(
        children: [
          Text(_viewModel?.role == true ? '法人' : '代理人',
              style: TextStyle(fontSize: 16)),
          Image.asset(
            'lib/assets/images/chevron_left.png',
            width: 24,
            height: 24,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  /// 角色弹窗选择
  showRoleDialog() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(right: 20),
                        alignment: Alignment.center,
                        child: Text('取消'),
                      ),
                    ),
                  ],
                ),
                Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _viewModel.role = true;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text('法人'),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _viewModel.role = false;
                      });
                    },
                    child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        )),
                        child: Text('代理人')),
                  ),
                ]),
              ],
            ),
          );
        });
  }

  Widget _buildInputRow(
      String label, String hint, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 10,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400]),
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    print("title:${title.substring(0,4)}");
    return Container(
      padding: EdgeInsets.only(left: 30, top: 16, bottom: 16),
      alignment: Alignment.centerLeft,
      child: title.contains("签章图片") ? RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title.substring(0,4),
              style: TextStyle(fontSize: 16,color:Colors.black, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: title.substring(4, title.length),
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      ) : Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildImageCard(
      {String label, String img, VoidCallback onPick, VoidCallback onDelete}) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: img == null
            ? GestureDetector(
                onTap: onPick,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        size: 32, color: Colors.grey[500]),
                    SizedBox(height: 6),
                    Text(label != null ? label : '上传图片',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[500])),
                  ],
                ),
              )
            : GestureDetector(
                onTap: onDelete,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(img, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(2),
                          child:
                              Icon(Icons.remove, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.entity != null) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _viewModel.role = widget.entity.userType == 1 ? true : false;
          _nameController.text = widget.entity.enterpriseName;
          _orgCodeController.text = widget.entity.organizationCode;
          businessImg = widget.entity.businessLicenseFile;
          sealImg = widget.entity.enterpriseSealUrl;
          idFrontImg  = widget.entity.idFrontFile;
          idBackImg = widget.entity.idBackFile;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: commonAppBar(title: '申请/编辑签章'),
      body: Consumer<UserViewModel>(
        builder: (_, model, __) {
          return ProviderWidget<MySignatureApplyViewModel>(
            model: MySignatureApplyViewModel(),
            onModelReady: (viewModel) {
              _viewModel = viewModel;
            },
            builder: (context, viewModel, child) {
              return Container(
                color: AppTheme.bg_b,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: AppTheme.bg_b,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    _buildRoleSelector(),
                                    Divider(height: 1),
                                    _buildInputRow(
                                        '企业名称', '请输入企业名称', _nameController),
                                    Divider(height: 1),
                                    _buildInputRow(
                                        '机构代码', '请输入机构代码', _orgCodeController),
                                    Divider(height: 8, color: Color(0xFFF7F8FA)),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle("营业执照"),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, bottom: 15),
                                      child: _buildImageCard(
                                        img: businessImg,
                                        onPick: () {
                                          _showDialog("businessImg");
                                        },
                                        onDelete: () {
                                          setState(() => businessImg = null);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('签章图片（限透明底PNG图片）'),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, bottom: 15),
                                        child: _buildImageCard(
                                          img: sealImg,
                                          onPick: () {
                                            _showDialog("sealImg");
                                          },
                                          onDelete: () {
                                            setState(() => sealImg = null);
                                          },
                                        ),
                                      ),
                                    ]),
                              ),
                              Offstage(
                                offstage: _viewModel.role,
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(top: 15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('法人证件照'),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, bottom: 15),
                                        child: Row(
                                          children: [
                                            _buildImageCard(
                                              label: '上传正面',
                                              img: idFrontImg,
                                              onPick: () {
                                                _showDialog("idFrontImg");
                                              },
                                              onDelete: () {
                                                setState(() => idFrontImg = null);
                                              },
                                            ),
                                            SizedBox(width: 18),
                                            _buildImageCard(
                                              label: '上传反面',
                                              img: idBackImg,
                                              onPick: () {
                                                _showDialog("idBackImg");
                                              },
                                              onDelete: () {
                                                setState(() => idBackImg = null);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(bottom: 32, top: 10, left: 16, right: 16),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1890FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        onPressed: ThrottleUtil().throttle(() {
                          if (_nameController.text.isEmpty) {
                            ToastUtil.showErrorToast("请输入企业名称");
                            return;
                          }
                          if (_orgCodeController.text.isEmpty) {
                            ToastUtil.showErrorToast("请输入组织机构代码");
                            return;
                          }
                          if (businessImg == null || businessImg.isEmpty) {
                            ToastUtil.showErrorToast("请上传营业执照");
                            return;
                          }

                          if (sealImg == null || sealImg.isEmpty) {
                            ToastUtil.showErrorToast("请上传签章图片");
                            return;
                          }
                          if (!_viewModel.role) {
                            if (idFrontImg == null || idFrontImg.isEmpty) {
                              ToastUtil.showErrorToast("请上传身份证正面");
                              return;
                            }
                            if (idBackImg == null || idBackImg.isEmpty) {
                              ToastUtil.showErrorToast("请上传身份证反面");
                              return;
                            }
                          }
                           _viewModel.faceCompare((faceId){
                            if (widget.isUpdate) {
                              var data = {
                                "businessLicenseFile": businessImg,
                                "enterpriseName": _nameController.text,
                                "enterpriseSealUrl": sealImg,
                                "idBackFile": idBackImg,
                                "idFrontFile": idFrontImg,
                                "organizationCode": _orgCodeController.text,
                                "unitGuid": widget.entity.unitGuid,
                                "userType": _viewModel.role ? 1 : 2,
                                "faceId":faceId,
                              };
                              _viewModel.updateOrderInfo(data);
                            } else {
                              var data = {
                                "businessLicenseFile": businessImg,
                                "enterpriseName": _nameController.text,
                                "enterpriseSealUrl": sealImg,
                                "idBackFile": idBackImg,
                                "idFrontFile": idFrontImg,
                                "organizationCode": _orgCodeController.text,
                                "userType": _viewModel.role ? 1 : 2,
                                "faceId":faceId,
                              };
                              _viewModel.addEnterprise(data);
                            }
                          });
                        }),
                        child: Text('下一步', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
