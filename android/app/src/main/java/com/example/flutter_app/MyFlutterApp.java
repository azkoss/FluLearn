package com.example.flutter_app;

import android.content.res.Configuration;
import android.content.res.Resources;

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

    // 解决APP字体随系字体大小改变造成的布局错位问题
    @Override
    public Resources getResources() {
        Resources resources = super.getResources();
        Configuration configuration = new Configuration();
        configuration.setToDefaults();
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
        return resources;
    }

}
