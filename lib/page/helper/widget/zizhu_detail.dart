import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/fade_route.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/photo_view_gallery.dart';
import 'package:notarization_station_app/components/star/span_rating_widget.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/helper/vm/helper_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/helper_api.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ZiZhuDetailPage extends StatefulWidget {
  final arguments;
  const ZiZhuDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ZiZhuDetailState();
  }
}

class ZiZhuDetailState extends BaseState<ZiZhuDetailPage>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController audioPlayerController;
  VideoPlayerController betterPlayerController;
  ChewieController chewieController;
  bool isVideo = false;
  AudioPlayer audioPlayer;
  Duration position;
  Duration duration;
  double sliderValue;
  bool isPlaying = false;

  bool isInput = true;
  int score = 0;
  String remarks = '';

  @override
  void initState() {
    super.initState();
    getById();

    if (widget.arguments["videoPath"] != null ||
        widget.arguments["screencapPath"] != null) {
      betterPlayerController = VideoPlayerController.network(
          Config.splicingImageUrl(widget.arguments["videoPath"] != null
              ? widget.arguments["videoPath"]
              : widget.arguments["screencapPath"]));
      chewieController = ChewieController(
        videoPlayerController: betterPlayerController,
        autoPlay: false,
        looping: true,
      );

      setState(() {});
    } else if (widget.arguments["soundRecording"] != null) {
      audioPlay();
    }
  }

  //公证评分详情
  getById() async {
    // wjPrint(" widget.arguments: "+ widget.arguments["data"]);
    var map = {
      "orderId": widget.arguments["unitGuid"],
    };
    HelperApi.getSingleton().getById(map).then((value) {
      // wjPrint('=====================================value========================================= '+value.toString());
      // wjPrint('======value["code"]====== '+value["code"].toString());
      // wjPrint('======value["data"]["score"]====== '+value["data"]["score"].toString());
      // wjPrint('======value["data"]["remarks"]====== '+value["data"]["remarks"].toString());
      if (value["data"] != null) {
        // wjPrint('获取评价详情');
        isInput = false;
        score = value["data"]["score"] != null
            ? int.parse(value["data"]["score"])
            : 0;
        remarks = value["data"]["remarks"] ?? '';
        setState(() {});
      } else {
        // wjPrint('添加评价详情');
        isInput = true;
        setState(() {});
      }
    });
  }

  audioPlay() async {
    audioPlayer = new AudioPlayer();
    // ignore: deprecated_member_use
    audioPlayer
      ..onDurationChanged.listen((duration) {
        this.duration = duration;
        if (position != null) {
          this.sliderValue = (position.inSeconds / duration.inSeconds);
        }
        setState(() {});
      })
      // ignore: deprecated_member_use
      ..positionHandler = ((position) {
        setState(() {
          this.position = position;
          if (duration != null) {
            this.sliderValue = (position.inSeconds / duration.inSeconds);
          }
        });
      })
      ..onPlayerCompletion.listen((event) {
        wjPrint("播放完毕了");
        setState(() {
          isPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    betterPlayerController?.dispose();
    audioPlayerController?.dispose();
    audioPlayer?.release();
  }

  String _formatDuration(Duration d) {
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  HelpViewModel quizVm;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: Scaffold(
        appBar: commonAppBar(title: "自助存证订单详情"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<HelpViewModel>(
                model: HelpViewModel(userModel),
                onModelReady: (model) {
                  quizVm = model;
                },
                builder: (ctx, vm, child) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ColoredBox(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getWidthPx(40),
                                  top: getWidthPx(30),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      "基本信息",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(40),
                                    top: getWidthPx(15),
                                    right: getWidthPx(40)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "姓名",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text(widget.arguments['userName'] ?? '',
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(40),
                                    top: getWidthPx(15),
                                    right: getWidthPx(40)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "地址",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    SizedBox(
                                      width: getWidthPx(20),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.arguments['address']}",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(40),
                                    top: getWidthPx(15),
                                    right: getWidthPx(40)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "存证时间",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.arguments['createDate'],
                                        style: const TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.right,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(40),
                                    top: getWidthPx(15),
                                    right: getWidthPx(40)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "金额",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text("${widget.arguments['fee']}",
                                        style: const TextStyle(
                                            color: Colors.black))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(40),
                                    top: getWidthPx(15),
                                    bottom: getWidthPx(15),
                                    right: getWidthPx(40)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "支付状态",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text(
                                        widget.arguments['isPay'] == 1
                                            ? "已支付"
                                            : "未支付",
                                        style: const TextStyle(
                                            color: Colors.black))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getHeightPx(20),
                        ),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(40), top: getWidthPx(30)),
                                child: Text(
                                  "电子证书",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              widget.arguments['filePath'] == null
                                  ? Text("暂无数据")
                                  : SizedBox(
                                      width: getWidthPx(300),
                                      height: getWidthPx(300),
                                      child: InkWell(
                                        onTap: () {
                                          List imgArr = [];
                                          imgArr.add(Config.splicingImageUrl(
                                              widget.arguments['filePath']));
                                          Navigator.of(context).push(FadeRoute(
                                              page: PhotoViewGalleryScreen(
                                                  images: imgArr, //传入图片list
                                                  index: 0, //传入当前点击的图片的index
                                                  heroTag: "1")));
                                        },
                                        child: FadeInImage.assetNetwork(
                                          imageCacheWidth: 800,
                                          imageCacheHeight: 800,
                                          placeholder:
                                              'lib/assets/images/empty.png',
                                          image: Config.splicingImageUrl(
                                              widget.arguments['filePath']),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          height: getHeightPx(20),
                          color: AppTheme.bg_d,
                        ),
                        SizedBox(
                          height: getHeightPx(20),
                        ),
                        ColoredBox(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getWidthPx(40),
                                  top: getWidthPx(30),
                                ),
                                child: const Text(
                                  "存证信息",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getWidthPx(15),
                                      right: getWidthPx(40)),
                                  child: widget.arguments["videoPath"] !=
                                              null ||
                                          widget.arguments["screencapPath"] !=
                                              null
                                      ? AspectRatio(
                                          aspectRatio: 10 / 8,
                                          child: Chewie(
                                            controller: chewieController,
                                          ),
                                        )
                                      : widget.arguments["soundRecording"] !=
                                              null
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (isPlaying)
                                                      audioPlayer.pause();
                                                    else {
                                                      audioPlayer.play(widget
                                                          .arguments[
                                                      "soundRecording"]);
                                                    }
                                                    setState(() {
                                                      isPlaying = !isPlaying;
                                                      // widget.onPlaying(isPlaying);
                                                    });
                                                  },
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  icon: Icon(
                                                    isPlaying
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    size: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  position == null
                                                      ? "00:00"
                                                      : _formatDuration(
                                                          position),
                                                ),
                                                Text(
                                                  " / ",
                                                ),
                                                Text(
                                                  duration == null
                                                      ? "00:00"
                                                      : _formatDuration(
                                                          duration),
                                                ),
                                                Expanded(
                                                  child: Slider(
                                                    onChanged: (newValue) {
                                                      if (duration != null &&
                                                          isPlaying) {
                                                        int seconds = (duration
                                                                    .inSeconds *
                                                                newValue)
                                                            .round();
                                                        wjPrint(
                                                            "audioPlayer.seek: $seconds");
                                                        audioPlayer.seek(
                                                            new Duration(
                                                                seconds:
                                                                    seconds));
                                                        setState(() {});
                                                      }
                                                    },
                                                    value: sliderValue ?? 0.0,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              width: getWidthPx(300),
                                              height: getWidthPx(300),
                                              child: InkWell(
                                                  onTap: () {
                                                    List imgArr = [];
                                                    imgArr.add(
                                                        Config.splicingImageUrl(
                                                            widget.arguments[
                                                                'imgPath']));
                                                    Navigator.of(context).push(FadeRoute(
                                                        page: PhotoViewGalleryScreen(
                                                            images: imgArr, //传入图片list
                                                            index: 0, //传入当前点击的图片的index
                                                            heroTag: "1")));
                                                  },
                                                  child: Image.network(
                                                      Config.splicingImageUrl(
                                                          widget.arguments[
                                                              'imgPath'])))))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getHeightPx(20),
                        ),
                        ColoredBox(
                            color: Colors.white,
                            child: Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getWidthPx(40),
                                  top: getWidthPx(30),
                                ),
                                child: const Text(
                                  "服务评价",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              SponRatingWidget(
                                value: score,
                                evaluate: remarks,
                                isInput: isInput,
                                onRatingUpdate: (e, str) async {
                                  // wjPrint("服务评价: $e   $str");
                                  vm.textEditingController.text = str;
                                  vm.orderId = widget.arguments["unitGuid"];
                                  vm.score = e.toString();
                                  vm.addScore();
                                  setState(() {
                                    score = int.parse(vm.score);
                                    isInput = vm.isBool;
                                  });
                                },
                              ),
                            ])),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
