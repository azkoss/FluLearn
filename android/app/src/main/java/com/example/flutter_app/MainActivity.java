package com.example.flutter_app;

import android.os.Bundle;

import com.example.flutter_app.util.BridgeUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        final FlutterView flutterView = getFlutterView();
        flutterView.addFirstFrameListener(new FlutterView.FirstFrameListener() {
            public void onFirstFrame() {
                android.util.Log.w(null, "First frame of FlutterView is finished");
                flutterView.removeFirstFrameListener(this);
            }
        });

        BridgeUtils.installApk(flutterView);
    }

}
