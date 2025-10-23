import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../model/datum.dart';
import '../../utils/alert_view.dart';
import '../../utils/global.dart';

class ElectronicNotarialCertificate extends StatefulWidget {
  final String unitGuid;
  const ElectronicNotarialCertificate({Key key, this.unitGuid})
      : super(key: key);

  @override
  State<ElectronicNotarialCertificate> createState() =>
      _ElectronicNotarialCertificateState();
}

class _ElectronicNotarialCertificateState
    extends State<ElectronicNotarialCertificate> {
  int selectIndex = 0;

  String unitGuid = "";

  List<Datum> fileList = [];

  List videoPlayControllerList = [];
  List chewieControllerList = [];

  String documentUrl = "";

  PageController pageController = PageController(initialPage: 0);

  void changePageView(int index) {
    if(!mounted){
      return;
    }
    setState(() {
      selectIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      index == 0 ? generatePdfToImg() : getVerifyCertificate();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unitGuid = widget.unitGuid;
    generatePdfToImg();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (chewieControllerList.isNotEmpty) {
      for (var element in chewieControllerList) {
        element.dispose();
      }
    }
    if (videoPlayControllerList.isNotEmpty) {
      for (var element in videoPlayControllerList) {
        element.dispose();
      }
    }
    super.dispose();
  }

  // 获取文件列表
  void generatePdfToImg() {
    if (ObjectUtil.isEmpty(unitGuid)) {
      EasyLoading.showToast("文件id为空");
      return;
    }
    HomeApi.getSingleton().generatePdfToImg({"unitGuid": unitGuid},
        errorCallBack: (e) {
      EasyLoading.showToast("获取公证书列表失败");
    }).then((value) {
      if (ObjectUtil.isNotEmpty(value) && value["code"] == 200) {
        fileList.clear();
        if (ObjectUtil.isNotEmpty(value["data"])) {
          if(!mounted){
            return;
          }
          setState(() {
            for (var element in value["data"]) {
              fileList.add(Datum.fromMap(element));
            }
          });
          print("fileList------$fileList");
        } else {
          EasyLoading.showToast("获取公证书列表失败");
        }
      }
    });
  }

  // 获取验证证书
  void getVerifyCertificate() async {
    if (ObjectUtil.isEmpty(unitGuid)) {
      EasyLoading.showToast("文件id为空");
      return;
    }
    HomeApi.getSingleton().getCertificateUrl({"unitGuid": unitGuid},
        errorCallBack: (e) {
      EasyLoading.showToast("获取验证证书失败");
    }).then((value) {
      if (ObjectUtil.isNotEmpty(value) && value["code"] == 200) {
        if(!mounted){
          return;
        }
        setState(() {
          documentUrl = value["data"];
        });
      } else {
        EasyLoading.showToast("获取验证证书失败");
      }
    });
  }

  // 电子公证书文件下载
  void downloadCertificateAnnex() async {
    if (ObjectUtil.isEmpty(unitGuid)) {
      EasyLoading.showToast("文件id为空");
      return;
    }
    EasyLoading.show(status: "下载中...");
    HomeApi.getSingleton().downloadCertificateAnnex({"unitGuid": unitGuid},
        errorCallBack: (e) {
      EasyLoading.showToast("下载电子公证书文件失败");
      EasyLoading.dismiss();
    }).then((value) async {
      EasyLoading.dismiss();
      if (ObjectUtil.isNotEmpty(value)&&
          value["code"] == 200) {
        // showCopyLinkAlert(url: value.body['data']['url'], onConfirm: (){
        //   showDownloadFileNoPauseAlert(
        //       url: value.body['data']['url'],
        //       fileSize: value.body['data']['fileSize'],
        //       fileName: value.body['data']['fileName']);
        // });
        if (!await Permission.storage.status.isGranted) {
          G.showCustomToast(
            context: G.getCurrentState().overlay.context,
            titleText: "文件存储权限使用说明：",
            subTitleText: "用于文件存储等场景",
            time: 2,
          );
        }
        if (await Permission.storage.request().isGranted) {
          showCopyLinkAlert(
              url: value['data']['url'],
              context: context,
              onConfirm: () {
                showDownloadFileNoPauseAlert(
                  url: value['data']['url'],
                  fileSize: value['data']['fileSize'],
                  fileName: value['data']['fileName'],
                  type: DownloadType.electronicNotarialFileDownload,
                );
              });
        } else {
          G.showPermissionDialog(str: '访问内部存储权限');
        }
      } else {
        EasyLoading.showToast("下载电子公证书文件失败");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text(
        "预览",
        style: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          leading: IconButton(onPressed: (){
            G.pop();
          }, icon: Icon(Icons.arrow_back_ios),iconSize: 25,color: AppTheme.textBlack,),
          centerTitle: true,
          backgroundColor: AppTheme.white,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 45),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          changePageView(0);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          decoration: BoxDecoration(
                            color: selectIndex == 0
                                ? AppTheme.themeBlue.withAlpha(100)
                                : AppTheme.white,
                            border: Border.all(
                              width: 1.0,
                              color: selectIndex == 0
                                  ? Colors.transparent
                                  : AppTheme.lightText,
                            ),
                          ),
                          child: Text("公证书",
                              style: TextStyle(
                                color: selectIndex == 0
                                    ? AppTheme.themeBlue
                                    : AppTheme.lightText,
                                fontSize: 16,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          changePageView(1);
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectIndex == 1
                                ? AppTheme.themeBlue.withAlpha(100)
                                : AppTheme.white,
                            border: Border.all(
                              width: 1.0,
                              color: selectIndex == 1
                                  ? Colors.transparent
                                  : AppTheme.lightText,
                            ),
                          ),
                          child: Text(
                            "验证证书",
                            style: TextStyle(
                              color: selectIndex == 1
                                  ? AppTheme.themeBlue
                                  : AppTheme.lightText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildNotarialCertificate(), _buildVerifyCertificate()],
      ),
    );
  }

  // 公证书
  Widget _buildNotarialCertificate() {
    List<Widget> childrenList = [];
    if (fileList.isEmpty) {
      return const SizedBox();
    }
    for (var element in fileList) {
      if (ObjectUtil.isNotEmpty(element.fileType)) {
        if (element.fileType.contains('jpg') ||
            element.fileType.contains('png') ||
            element.fileType.contains('jpeg')) {
          childrenList.add(_buildImageShow(imageUrl: element.filePath));
        } else if (element.fileType.contains("MP4") ||
            element.fileType.contains("mp4") ||
            element.fileType.contains("avi") ||
            element.fileType.contains("AVI") ||
            element.fileType.contains("mov") ||
            element.fileType.contains("MOV") ||
            element.fileType.contains("wmv") ||
            element.fileType.contains("WMV") ||
            element.fileType.contains("flv") ||
            element.fileType.contains("FLV")) {
          if (element.fileType.contains("mp4") ||
              element.fileType.contains("MP4")) {
            _buildVideoPlay(videoUrl: element.filePath)
                .then((value) => childrenList.add(value));
          } else {
            // 该设备不支持播放mov格式文件
            childrenList.add(Container(
                height: 40,
                margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
                alignment: Alignment.center,
                child: Text(
                  '该设备不支持播放${element.fileType ?? "当前"}格式文件',
                )));
          }
        } else if (element.fileType.contains("mp3") ||
            element.fileType.contains("MP3") ||
            element.fileType.contains("wav") ||
            element.fileType.contains("WAV") ||
            element.fileType.contains("AAC") ||
            element.fileType.contains("aac")) {
          _buildAudioPlay(audioUrl: element.filePath)
              .then((value) => childrenList.add(value));
        } else if (element.fileType.contains("rar") ||
            element.fileType.contains("zip")) {
          childrenList.add(_buildZipShow(fileName: element.fileName));
        } else {
          childrenList.add(Container(
              height: 40,
              margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
              alignment: Alignment.center,
              child: Text(
                '该设备不支持播放${element.fileType ?? "当前"}格式文件',
              )));
        }
      } else {
        childrenList.add(Container(
            height: 40,
            margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
            alignment: Alignment.center,
            child: Text(
              '该设备不支持播放${element.fileType ?? "当前"}格式文件',
            )));
      }
    }
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: childrenList,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(30.0),
            child: InkWell(
              onTap: ThrottleUtil().throttle(() {
                downloadCertificateAnnex();
              }),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppTheme.themeBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("全部下载",style: TextStyle(color: AppTheme.white)),
              ),
            )),
      ],
    );
  }

  // 验证证书
  Widget _buildVerifyCertificate() {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: documentUrl.isEmpty
                ? const SizedBox()
                : FadeInImage.assetNetwork(
                placeholder: "lib/assets/images/image_placeholder.png",
                image: documentUrl),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(30.0),
          child: InkWell(
            onTap: ThrottleUtil().throttle(() {
              downloadCertificateAnnex();
            }),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppTheme.themeBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("全部下载",style: TextStyle(color: AppTheme.white)),
            ),
          )),
    ]);
  }

  // 视频播放界面
  Future<Widget> _buildVideoPlay({String videoUrl}) async {
     VideoPlayerController videoPlayerController;
    if (ObjectUtil.isNotEmpty(videoUrl) && videoUrl.contains('http')) {
      try {
        videoPlayerController = VideoPlayerController.network(videoUrl);
        await videoPlayerController.initialize();
        ChewieController chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: false,
          looping: false,
        );
        videoPlayControllerList.add(videoPlayerController);
        chewieControllerList.add(chewieController);
        return Container(
          margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
          color: AppTheme.white,
          child: Chewie(
            controller: chewieController,
          ),
        );
      } catch (e) {
        return Container(
            margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
            alignment: Alignment.center,
            child: Text(
              '该设备不支持当前视频编码格式播放',
            ));
      }
    } else {
      return Container(
          margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            '链接地址错误，无法播放',
          ));
    }
  }

  // 图片展示界面
  Widget _buildImageShow({String imageUrl}) {
    if (ObjectUtil.isNotEmpty(imageUrl) && imageUrl.contains('http')) {
      return Container(
        margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
        alignment: Alignment.center,
        child: FadeInImage.assetNetwork(
          placeholder: "lib/assets/images/image_placeholder.png",
          image: imageUrl,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
          margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            '链接地址错误，无法播放',
          ));
    }
  }

  // 录音播放界面
  Future<Widget> _buildAudioPlay({String audioUrl}) async {
     VideoPlayerController videoPlayerController;
    if (ObjectUtil.isNotEmpty(audioUrl) && audioUrl.contains('http')) {
      try {
        // videoPlayerController = VideoPlayerController.network(audioUrl);
        // await videoPlayerController.initialize();
        // ChewieController chewieController = ChewieController(
        //   videoPlayerController: videoPlayerController,
        //   autoPlay: false,
        //   looping: false,
        // );
        // videoPlayControllerList.add(videoPlayerController);
        // chewieControllerList.add(chewieController);


        return Container(
          margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
          color: AppTheme.white,
          child: PlayAudioWidget(
            audioUrl: audioUrl,
          ),
        );
      } catch (e) {
        return Container(
            margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
            alignment: Alignment.center,
            child: Text(
              '该设备不支持当前音频编码格式播放',
            ));
      }
    } else {
      return Container(
          margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            '链接地址错误，无法播放',
          ));
    }
  }

  // 压缩文件展示界面
  Widget _buildZipShow({String fileName}) {
    return Container(
        margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
        height: 100,
        alignment: Alignment.center,
        child: Row(
          children: [
            Image.asset(
              "lib/assets/images/icon_zip.png",
              width: 50,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(fileName ?? ''),
            )
          ],
        ));
  }
}

class PlayAudioWidget extends StatefulWidget {
  final String audioUrl;
  const PlayAudioWidget({Key key,this.audioUrl}) :super (key: key);

  @override
  State<PlayAudioWidget> createState() => _PlayAudioWidgetState();
}

class _PlayAudioWidgetState extends State<PlayAudioWidget> {
  AudioPlayer audioPlayer = AudioPlayer();

  Duration _duration;
  Duration _position;
  AudioPlayerState _playerState;

  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == AudioPlayerState.PLAYING;

  bool get _isPaused => _playerState == AudioPlayerState.PAUSED;

  String get _durationText => _duration.toString().split('.').first ?? '';

  String get _positionText => _position.toString().split('.').first ?? '';

  @override
  void initState() {
    super.initState();
    audioPlayer.setUrl(widget.audioUrl);
     audioPlayer.getDuration().then((value){
       setState(() {
         _duration = Duration(microseconds: value);
       });
     });
     audioPlayer.getCurrentPosition().then((value) {
       setState(() {
         _position = Duration(microseconds: value);
       });
     });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      setState(() {
        _playerState = state;
      });
    });
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void _initStreams() {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = audioPlayer.onAudioPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _playerState = AudioPlayerState.STOPPED;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          color: Colors.black,
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(_playerState == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
              iconSize: 20.0,
              onPressed: () {
                if (_playerState == AudioPlayerState.PLAYING) {
                  audioPlayer.pause();
                } else {
                  audioPlayer.play(widget.audioUrl, isLocal: false);
                }
              },
            ),
            Expanded(child: Slider(

              onChanged: (value) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = value * duration.inMilliseconds;
                audioPlayer.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                  _duration != null &&
                  _position.inMilliseconds > 0 &&
                  _position.inMilliseconds < _duration.inMilliseconds)
                  ? _position.inMilliseconds / _duration.inMilliseconds
                  : 0.0,
            ),),
            Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                  ? _durationText
                  : '',
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ],
    );
  }
}

