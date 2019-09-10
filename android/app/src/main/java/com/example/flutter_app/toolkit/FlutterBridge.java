package com.example.flutter_app.toolkit;

import android.content.Context;
import android.content.Intent;

import com.example.flutter_app.MyFlutterApp;

import java.io.File;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

/**
 * Android原生与Flutter交互的桥梁
 *
 * @author liyujiang
 */
public class FlutterBridge {
    private static final String CHANNEL_NAME = "gzu-liyujiang/bridge";

    public static void installApk(FlutterView flutterView) {
        new MethodChannel(flutterView, CHANNEL_NAME).setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals("installApk")) {
                String path = methodCall.argument("path");
                _installApk(flutterView.getContext(), path);
            } else {
                result.notImplemented();
            }
        });
    }

    private static void _installApk(Context context, String path) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        VersionCompat.setIntentDataAndType(context, intent, "application/vnd.android.package-archive", new File(path), false);
        context.startActivity(intent);
    }

    public static void exitApp(FlutterView flutterView) {
        new MethodChannel(flutterView, CHANNEL_NAME).setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals("exitApp")) {
                Boolean forceKill = methodCall.argument("forceKill");
                MyFlutterApp.exitApp(forceKill == null ? false : forceKill);
            } else {
                result.notImplemented();
            }
        });
    }

}
