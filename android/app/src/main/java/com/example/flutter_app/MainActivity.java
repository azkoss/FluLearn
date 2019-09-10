package com.example.flutter_app;

import android.content.res.Configuration;
import android.os.Bundle;

import com.example.flutter_app.toolkit.FlutterBridge;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {
    private static final boolean BRIGHTNESS_DARK = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        final FlutterView flutterView = getFlutterView();
        flutterView.addFirstFrameListener(new FlutterView.FirstFrameListener() {
            public void onFirstFrame() {
                android.util.Log.d(MyFlutterApp.LOG_TAG, "First frame of FlutterView load finished");
                flutterView.removeFirstFrameListener(this);
            }
        });

        FlutterBridge.installApk(flutterView);
        FlutterBridge.exitApp(flutterView);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        android.util.Log.d(MyFlutterApp.LOG_TAG, "configuration changed: " + newConfig);
    }

}
