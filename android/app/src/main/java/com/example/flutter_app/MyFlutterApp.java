package com.example.flutter_app;

import io.flutter.app.FlutterApplication;

/**
 * Flutter APP
 *
 * @author liyujiang
 */
public class MyFlutterApp extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        android.util.Log.w(null, "Android native is finished");
    }

}
