package com.example.flutter_app.util;

import android.content.Context;
import android.content.Intent;

import java.io.File;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

/**
 * Android原生与Flutter交互
 *
 * @author liyujiang
 */
public class BridgeUtils {
    private static final String CHANNEL_NAME = "bridge";

    public static void installApk(FlutterView flutterView) {
        new MethodChannel(flutterView, CHANNEL_NAME).setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals("installApk")) {
                Context context = flutterView.getContext();
                String path = methodCall.argument("path");
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                CompatUtils.setIntentDataAndType(context, intent, "application/vnd.android.package-archive", new File(path), false);
                context.startActivity(intent);
            } else {
                result.notImplemented();
            }
        });
    }

}
