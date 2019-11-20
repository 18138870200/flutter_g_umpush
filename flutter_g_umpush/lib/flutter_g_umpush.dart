import 'dart:async';

import 'package:flutter/services.dart';

class FlutterGUmpush {

  static StreamController<Map> _recvNotificationListener =
  new StreamController.broadcast();
  static StreamController<Map> _recvOpenNotificationListener =
  new StreamController.broadcast();
  static StreamController<Map> _recvCustomMsgController =
  new StreamController.broadcast();

  static Map<Function, StreamSubscription> listeners = {};


  /**
   * 监听：接收推送事件
   */
  static void addReceiveNotificationListener(
      void onData(Map notification)) {
    listeners[onData] = _recvNotificationListener.stream.listen(onData);
  }

  /**
   * 取消监听：接收推送事件
   */
  static void removeReceiveNotificationListener(
      void onData(Map notification)) {
    removeListener(onData);
  }

  /**
   * 监听：点击推送事件
   */
  static void addReceiveOpenNotificationListener(
      void onData(Map notification)) {
    listeners[onData] = _recvOpenNotificationListener.stream.listen(onData);
  }

  /**
   * 取消监听：点击推送事件
   */
  static void removeReceiveOpenNotificationListener(
      void onData(Map notification)) {
    removeListener(onData);
  }

  /**
   * 监听：自定义消息后事件
   */
  static void addReceiveCustomMsgListener(void onData(Map data)) {
    listeners[onData] = _recvCustomMsgController.stream.listen(onData);
  }

  /**
   * 取消监听：自定义消息后事件
   */
  static void removeReceiveCustomMsgListener(void onData(Map data)) {
    removeListener(onData);
  }

  static void removeListener(void onData(dynamic data)) {
    StreamSubscription listener = listeners[onData];
    if (listener == null) return;
    listener.cancel();
    listeners.remove(onData);
  }



  static const MethodChannel _channel =
      const MethodChannel('flutter_g_umpush');


  static Future<dynamic> _handler(MethodCall call) {
    //print("handle mehtod call ${call.method} ${call.arguments}");
    String method = call.method;
    switch (method) {
      case 'receivePushMsg':
        {
          var map = call.arguments;
          _recvCustomMsgController.add(map);
        }
        break;
      case 'openNotification':
        {
          dynamic dic = call.arguments;
          _recvOpenNotificationListener
              .add(dic);
        }
        break;
      case 'receiveNotification':
        {
          dynamic dic = call.arguments;
          _recvNotificationListener
              .add(dic);
        }
        break;
    }
    return new Future.value(null);
  }




  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //初始化um推送
  static Future<bool> initWithAppkey(String appKey, String channel) async {
    _channel.setMethodCallHandler(_handler);
    final bool result = await _channel.invokeMethod('initWithAppkey',{"appKey":appKey,"channel":channel});
    return result;
  }

  //设置别名
  static Future<bool> addAlias(String account) async {
    final bool result = await _channel.invokeMethod('addAlias',account);
    return result;
  }

  //设置标签
  static Future<bool> addtags(String tag) async {
    final bool result = await _channel.invokeMethod('addtags',tag);
    return result;
  }

  //设置标签
  static Future<bool> setBadgeClear(bool isClear) async {
    final bool result = await _channel.invokeMethod('setBadgeClear',isClear);
    return result;
  }

  //设置标签
  static Future<bool> setAutoAlert(bool isAlert) async {
    final bool result = await _channel.invokeMethod('setAutoAlert',isAlert);
    return result;
  }


}
