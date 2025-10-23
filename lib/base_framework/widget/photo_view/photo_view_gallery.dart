import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

//onTap: (){
////使用方法
////FadeRoute是自定义的切换过度动画（渐隐渐现） 如果不需要 可以使用默认的MaterialPageRoute
//List<String> headerList=[];
//headerList.add(userData.headIcon);
//Navigator.of(context).push(new FadeRoute(page: PhotoViewGalleryScreen(
//images:headerList,//传入图片list
//index: 0,//传入当前点击的图片的index
//heroTag: userData.headIcon,//传入当前点击的图片的hero tag （可选）
//)));
//}
class PhotoViewGalleryScreen extends StatefulWidget {
  List images = [];
  int index = 0;
  String heroTag;
  PageController controller;
  double height;
  VoidCallback onTop;
  VoidCallback onWillPop;
  bool isBase64 = false;

  PhotoViewGalleryScreen({
    Key key,
    @required this.images,
    this.index,
    this.controller,
    this.height,
    this.onTop,
    this.onWillPop,
    this.heroTag,
    this.isBase64,
  }) : super(key: key) {
    controller = PageController(initialPage: index);
  }

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<PhotoViewGalleryScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: widget.onWillPop,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 10,
              right: 10,
              bottom: 0,
              child: Container(
                  color: Colors.transparent,
                  height: widget.height,
                  alignment: Alignment.center,
                  child: PhotoViewGallery.builder(
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: widget.isBase64
                            ? MemoryImage(widget.images[index])
                            : NetworkImage(widget.images[index].toString()),
                        heroAttributes: widget.heroTag.isNotEmpty
                            ? PhotoViewHeroAttributes(tag: widget.heroTag)
                            : null,
                      );
                    },
                    itemCount: widget.images.length,
                    pageController: widget.controller,
                    enableRotation: true,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  )),
            ),
            Positioned(
              //图片index显示
              bottom: 50,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text("${currentIndex + 1}/${widget.images.length}",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
//          Positioned(
//            //右上角关闭按钮
//            right: -10,
//            bottom: widget.height-30,
//            child: IconButton(
//              icon: Icon(
//                Icons.close,
//                size: 30,
//                color: Colors.white,
//              ),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: widget.onTop,
                child: Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text('已查阅',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
