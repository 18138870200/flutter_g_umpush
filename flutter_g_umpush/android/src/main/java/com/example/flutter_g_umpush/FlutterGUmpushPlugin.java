package com.example.flutter_g_umpush;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;



/** FlutterGUmpushPlugin */
public class FlutterGUmpushPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_g_umpush");
    channel.setMethodCallHandler(new FlutterGUmpushPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("initWithAppkey")){

      initWithAppkey(call.argument("appKey"),call.argument("channel"));
      result.success(true);
    }else if (call.method.equals("setAutoAlert")){

      System.out.println(call.arguments);
//      boolean isAlert = call.arguments;
      setAutoAlert(true);
      result.success(true);
    }else if (call.method.equals("setBadgeClear")){

      System.out.println(call.arguments);
      setAutoAlert(true);
      result.success(true);
    }else if (call.method.equals("addAlias")){

      result.success(true);
    }else if (call.method.equals("addtags")){

      result.success(true);
    } else {
      result.notImplemented();
    }
  }


  void initWithAppkey(String appKey, String channel ){
    System.out.println(appKey);
    System.out.println(channel);
    System.out.println("收到flutter数据");

  }
  void setAutoAlert(boolean isAlert){

  }
  void setBadgeClear(boolean isClear){

  }
  void addAlias(String account){

  }
  void addtags(String tag){

  }


}
