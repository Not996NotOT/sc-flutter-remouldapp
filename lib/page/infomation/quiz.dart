import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/quiz_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuizPageState();
  }
}

class QuizPageState extends BaseState<QuizPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  QuizModel quizVm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () {
        EasyLoading.dismiss();
        G.pop();
        return Future.value(false);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: commonAppBar(title: "提问"),
          backgroundColor: AppTheme.chipBackground,
          body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            return ProviderWidget<QuizModel>(
              model: QuizModel(userModel),
              onModelReady: (model) {
                quizVm = model;
              },
              builder: (ctx, vm, child) {
                return ColoredBox(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          "咨询内容：",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xfff0f0f0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          border:
                              Border.all(width: 1, color: AppTheme.Text_min),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: "请输入咨询内容",
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                  fontSize: 16.0, color: Color(0xff606266)),
                              controller: vm.textEditingController,
                              // cursorColor: Color(0xff00c295),
                              scrollPadding:
                                  const EdgeInsets.only(top: 0.0, bottom: 6.0),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(
                                    "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
                                LengthLimitingTextInputFormatter(200)
                              ],
                              minLines: 6,
                              maxLines: 6,
                            ),
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, //每行三列
                                  childAspectRatio: 1.0, //显示区域宽高相等
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: vm.imgList.length == 3
                                    ? 3
                                    : vm.imgList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index != 3) {
                                    return releaseImage(
                                        index == vm.imgList.length &&
                                            index != 3,
                                        index != vm.imgList.length
                                            ? vm.imgList[index]
                                            : null,
                                        index);
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  vm.isEnable ? Colors.blue : Colors.grey[200]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: const Text("提交咨询"),
                          onPressed: vm.isEnable
                              ? () {
                                  vm.addQuiz();
                                }
                              : null,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          })),
    );
  }

  Widget releaseImage(bool isDef, Asset asset, int i) {
    return isDef
        ? InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              quizVm.requestCameraPermission();
            },
            child: Image.asset("lib/assets/images/add_img.png"))
        : Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AssetThumb(
                  asset: asset,
                  width: 500,
                  height: 500,
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        quizVm.imgList.removeAt(i);
                        quizVm.imgListUrl.removeAt(i);
                        quizVm.notifyListeners();
                      },
                      child: Icon(Icons.clear, color: Colors.redAccent)))
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
