import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class PdfViewPage extends StatefulWidget {
  List images = [];
  int index = 0;
  double height;
  VoidCallback onTop;
  VoidCallback onWillPop;

  PdfViewPage({
    Key key,
    @required this.images,
    this.index,
    this.height,
    this.onTop,
    this.onWillPop,
  }) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.index;
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
              bottom: 60,
              left: 10,
              right: 10,
              child: Container(
                  color: Colors.transparent,
                  height: widget.height - 60,
                  child: Swiper(
                    control: new SwiperControl(),
                    physics: NeverScrollableScrollPhysics(),
                    index: 0,
                    // 横向
                    scrollDirection: Axis.horizontal,
                    //条目个数
                    itemCount: widget.images.length,
                    // 自动翻页
                    autoplay: false,
                    // 相邻子条目视窗比例
                    viewportFraction: 1,
                    // 布局方式
                    autoplayDisableOnInteraction: true,
                    // 无线轮播
                    loop: false,
                    //当前条目的缩放比例
                    scale: 1,
                    // 分页指示
                    pagination: SwiperPagination(
                      //指示器显示的位置
                      alignment: Alignment
                          .bottomCenter, // 位置 Alignment.bottomCenter 底部中间
                      // 距离调整
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      // 指示器构建
                      builder: FractionPaginationBuilder(
                          color: Colors.black54,
                          //选中时的颜色
                          fontSize: 12,
                          activeFontSize: 14,
                          activeColor: Colors.black54),
                    ),
                    //点击事件
                    onTap: (index) {},
                    itemBuilder: (BuildContext context, int index) {
                      return PDF.network(
                        widget.images[index],
                        height: double.infinity,
                        width: double.infinity,
                      );
                    },
                  )),
            ),
            // Positioned(
            //   //图片index显示
            //   bottom: 50,
            //   width: MediaQuery.of(context).size.width,
            //   child: Center(
            //     child: Text("${currentIndex + 1}/${widget.images.length}",
            //         style: TextStyle(color: Colors.white, fontSize: 16)),
            //   ),
            // ),
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
