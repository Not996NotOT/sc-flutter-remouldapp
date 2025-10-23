import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:notarization_station_app/config.dart';

import '../utils/common_tools.dart';

class MqttClientMsg {
  MqttServerClient client;

  Timer timer;

  static MqttClientMsg _instance;

  static MqttClientMsg get instance => _getInstance();

  static MqttClientMsg _getInstance() {
    if (_instance == null) {
      _instance = new MqttClientMsg();
    }
    return _instance;
  }

  ClientCallback clientCallback;

  void setCallback(ClientCallback clientCallback) {
    this.clientCallback = clientCallback;
  }

  Future<MqttServerClient> connect(String id) async {
    if (client == null) {
      wjPrint("client---------$client-----$id---");
      client = MqttServerClient(Config.mqttPath, 'flutter$id');
      client.useWebSocket = true;
      client.port = Config.mqttPort;
      client.logging(on: false);
      client.onConnected = onConnected;
      client.onDisconnected = onDisconnected;
      client.onUnsubscribed = onUnsubscribed;
      client.onSubscribed = onSubscribed;
      client.onSubscribeFail = onSubscribeFail;
      client.pongCallback = pong;
      client.onAutoReconnect = onAutoReconnect;
      client.autoReconnect = true;
      client.keepAlivePeriod = 20;
      client.setProtocolV311();

      final connMessage = MqttConnectMessage()
          .authenticateAs(Config.mqttAccount, Config.mqttPassword)
          .startClean();
      // final connMessage = MqttConnectMessage().authenticateAs('admin', 'aaaaaa').startClean();
      client.connectionMessage = connMessage;
      try {
        await client.connect();
      } catch (e) {
        log('出现错误Exception: $e');
        client?.disconnect();
        client = null;
      }
      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload;
        // final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        wjPrint(
            '消息 message:${utf8.decode(message.payload.message)} from 主题: ${c[0].topic}');
        try {
          if (clientCallback != null) {
            clientCallback.clientDataHandler(
                utf8.decode(message.payload.message),
                c[0].topic.toString().split("/")[2]);
          }
        } catch (e) {
          wjPrint('消息错误 message:$e');
        }
      });
    }
    return client;
  }

  // 连接成功
  void onConnected() {
    wjPrint('连接成功');
  }

  // 连接断开
  void onDisconnected() {
    wjPrint('连接断开');
    client = null;
  }

  // 订阅主题成功
  void onSubscribed(String topic) {
    wjPrint('订阅主题成功 topic: $topic');
  }

// 订阅主题失败
  void onSubscribeFail(String topic) {
    wjPrint('订阅主题失败 $topic');
  }

// 成功取消订阅
  void onUnsubscribed(String topic) {
    wjPrint('成功取消订阅: $topic');
  }

// 收到 PING 响应
  void pong() {
    wjPrint('收到 PING 响应');
  }

  // 开始订阅主题
  void subscribe(String topic) {
    client?.subscribe(topic, MqttQos.atLeastOnce);
  }

  // 订阅主题取消
  void unsubscribe(String topic) {
    client?.unsubscribe(topic);
  }

  // 断开连接
  void disconnect() {
    wjPrint('断开连接: ');
    client?.disconnect();
    client = null;
  }

  // 重新连接
  void onAutoReconnect() {
    wjPrint('这是正在重新连接: ');
  }

  // 消息发布
  postMessage(String message, String topic) {
    try {
      MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addUTF8String(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
      print('mqtt发送的消息:$message topic:$topic');
    } catch (e) {
      wjPrint("....发送消息的错误$e");
    }
  }
}

abstract class ClientCallback {
  void clientDataHandler(onData, topic);
}
