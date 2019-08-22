package com.example.flutter_app;

import io.flutter.app.FlutterApplication;

/**
 * @author liyujiang
 * @date 2019/8/22 16:59.
 */
public class MyFlutterApp extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        android.util.Log.w(null, "Android native is finished");
    }

}
