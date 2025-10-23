import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import '../entity/signature_entity.dart';


class SignatureCard extends StatefulWidget {
  final SignatureEntity entity;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final UserInfoEntity userInfo;

   SignatureCard({
    Key key,
    this.entity,
    this.onToggle,
    this.onEdit,
    this.onDelete,
     this.userInfo,
  }) : super(key: key);

  @override
  _SignatureCardState createState() => _SignatureCardState();
}

class _SignatureCardState extends State<SignatureCard> {

  SignatureEntity entity;

  bool isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    entity = widget.entity;
    isCheck  = widget.entity.status == 2 ? true : false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15,left: 15,right: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(entity.enterpriseName??'', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xffF9F9F9),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('申请人员：'),
                    Spacer(),
                    Text(widget.userInfo.userName??'')
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('申请时间：'),
                    Spacer(),
                    Text("${entity.createDate}"??'')
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('审批状态：'),
                    Spacer(),
                    Text(entity.status == 1 ? "待审核" : entity.status == 2 ? '启用' : entity.status == 3 ? "不通过":'禁用'),
                  ],
                ),
                Row(
                  children: [
                    Text('启用状态：'),
                    Spacer(),
                    CupertinoSwitch(
                        value: isCheck? true:false, onChanged: (value){
                          if (entity.status == 2 || entity.status == 4) {
                            setState(() {
                              isCheck  = value;
                              widget.onToggle(value);
                            });
                          } else {
                            ToastUtil.showWarningToast("签章未审核通过，无法进行此项操作！");
                          }

                    })
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Spacer(),
              Offstage(
                offstage: !(entity.status == 3),
                child: GestureDetector(
                  child: Container(
                    width: 80,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: AppTheme.themeBlue,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("编辑",style: TextStyle(color: AppTheme.themeBlue),),
                  ),
                  onTap: widget.onEdit,
                ),
              ),
              SizedBox(width: 10,),
              GestureDetector(
                child: Container(
                  width: 80,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Color(0XFFD0D2D6),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text("删除",style: TextStyle(color: Color(0XFF666666),)),
                ),
                onTap: widget.onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
