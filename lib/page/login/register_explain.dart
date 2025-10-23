import 'package:flutter/material.dart';

class RegisterExplainWidget extends StatelessWidget {
  const RegisterExplainWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '注册说明',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
        child: Text('''1.大陆用户仅支持11位大陆手机号进行注册。



2.境外用户支持境外手机号进行注册。



3.持有大陆居民身份证、定居国外中国公民护照、台湾居民来往内地通行证、港澳居民来往内地通行证、外国人永久居留身份证等证件类型的用户，均可自助注册并完成实名认证。其他证件类型的用户无法自助完成身份识别验证，需要在提交身份信息后经过人工审核后才能完成实名认证。

4.如有其他疑问，请使用大陆手机4008001820进行咨询。'''),
      ),
    );
  }
}
