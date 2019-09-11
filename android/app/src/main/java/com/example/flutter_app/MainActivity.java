package com.example.flutter_app;

import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

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

        letStatusBarTransparent();

        FlutterBridge.installApk(flutterView);
        FlutterBridge.exitApp(flutterView);
    }

    /**
     * 设置透明状态栏
     */
    private void letStatusBarTransparent() {
        Window window = getWindow();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(Color.TRANSPARENT);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        android.util.Log.d(MyFlutterApp.LOG_TAG, "configuration changed: " + newConfig);
    }

}
