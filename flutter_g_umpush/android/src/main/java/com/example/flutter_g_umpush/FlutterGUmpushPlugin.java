package com.example.flutter_g_umpush;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


//import com.umeng.commonsdk.UMConfigure;
//import com.umeng.message.IUmengRegisterCallback;
//import com.umeng.message.MsgConstant;
//import com.umeng.message.PushAgent;
//import com.umeng.message.UmengMessageHandler;
//import com.umeng.message.UmengNotificationClickHandler;


import static android.content.ContentValues.TAG;


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

      System.out.print(call.arguments);
      initWithAppkey("ddddd","ffffff");
      result.success(true);
    }else if (call.method.equals("setAutoAlert")){

      System.out.print(call.arguments);
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
    System.out.print(appKey);
    System.out.print(channel);
    System.out.print("收到flutter数据");




    UMConfigure.init(this, "替换为Appkey,服务后台位置：应用管理 -> 应用信息 -> Appkey", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "替换为秘钥信息,服务后台位置：应用管理 -> 应用信息 -> Umeng Message Secret");
//获取消息推送代理示例
    PushAgent mPushAgent = PushAgent.getInstance(this);
//注册推送服务，每次调用register方法都会回调该接口
    mPushAgent.register(new IUmengRegisterCallback() {

      @Override
      public void onSuccess(String deviceToken) {
        //注册成功会返回deviceToken deviceToken是推送消息的唯一标志
        Log.i(TAG,"注册成功：deviceToken：-------->  " + deviceToken);
      }

      @Override
      public void onFailure(String s, String s1) {
        Log.e(TAG,"注册失败：-------->  " + "s:" + s + ",s1:" + s1);
      }
    });

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
