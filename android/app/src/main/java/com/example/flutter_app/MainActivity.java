package com.example.flutter_app;

import android.os.Bundle;

import com.example.flutter_app.util.BridgeUtils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        BridgeUtils.installApk(getFlutterView());
    }

}
