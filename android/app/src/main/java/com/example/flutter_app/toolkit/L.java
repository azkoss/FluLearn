package com.example.flutter_app.toolkit;

import android.util.Log;

/**
 * 调试日志打印工具类
 *
 * @author liyujiang
 */
public class L {
    private static String logTag = CrashHandler.class.getSimpleName();
    private static boolean logEnable = false;

    public static void enable(String tag) {
        logTag = tag;
        logEnable = true;
    }

    public static boolean isDebug() {
        return logEnable;
    }

    public static void d(String msg) {
        if (logEnable) {
            //部分国产机屏蔽了WARN级别以下的日志，故用w代替d/i/v
            Log.w(logTag, msg);
        }
    }

    public static void e(String msg, Throwable t) {
        if (logEnable) {
            Log.e(logTag, msg, t);
        }
    }

}
