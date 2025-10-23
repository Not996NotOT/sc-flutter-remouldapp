import 'package:flutter/material.dart';

class StepsVehticalWidget extends StatefulWidget {
  List<String> data;
  StepsVehticalWidget({Key key, this.data}) : super(key: key);

  @override
  StepsVehticalWidgetState createState() => StepsVehticalWidgetState();
}

class StepsVehticalWidgetState extends State<StepsVehticalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            //如果显示到最后一个并且Icon总数小于200时继续获取数据
            return _buildItem(index);
          }),
    );
  }

  Widget _buildItem(int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.asset(
                    "lib/assets/images/stepper_noDone.png",
                    width: 14,
                    height: 14,
                  ),
                ),
                index != widget.data.length - 1
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Image.asset(
                          "lib/assets/images/stepper_verticalNoDone.png",
                          height: 20,
                          width: 5,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data[index],
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical:8.0),
                //   child: Text(widget.data[index].createDate??'',style: TextStyle(fontSize: 13,color: Colors.grey),),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
