import 'package:flutter/material.dart';
import 'package:flutter_network_speed/flutter_network_speed.dart';
import 'package:flutter_network_speed/speed_controller.dart';

class NetworkSpeedWidget extends StatefulWidget {
  const NetworkSpeedWidget({Key key}) : super(key: key);

  @override
  State<NetworkSpeedWidget> createState() => _NetworkSpeedWidgetState();
}

class _NetworkSpeedWidgetState extends State<NetworkSpeedWidget> {
  String uploadValue;

  String downloadValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listNetwork();
  }

  listNetwork() {
    SpeedController _speedController = SpeedController();
    SpeedController().addListener(() {
      setState(() {
        uploadValue = _speedController.value.uploadValue;
        downloadValue = _speedController.value.downloadValue;
      });
    });
    FlutterNetworkSpeed().initInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white12.withOpacity(0.2),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text("上行速度：$uploadValue kb/s"),
          Text("下行速度：$downloadValue kb/s"),
        ],
      ),
    );
  }
}
