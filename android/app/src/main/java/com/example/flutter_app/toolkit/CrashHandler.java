package com.example.flutter_app.toolkit;

import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.os.Build;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.NonNull;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.DateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Locale;
import java.util.concurrent.Executors;

/**
 * 未知异常处理
 *
 * @author liyujiang
 */
public class CrashHandler {
    private static final int MAX_STACK_TRACE_SIZE = 131071; //128 KB - 1
    private static Application application;

    /**
     * Installs this crash tool on the application using the default error activity.
     *
     * @param app Application to use for obtaining the ApplicationContext. Must not be null.
     * @see Application
     */
    public static void install(@NonNull Application app) {
        try {
            application = app;

            //INSTALL!
            Thread.UncaughtExceptionHandler oldHandler = Thread.getDefaultUncaughtExceptionHandler();

            String pkgName = application.getPackageName();
            L.d("current application package name is " + pkgName);
            if (oldHandler != null && oldHandler.getClass().getName().startsWith(pkgName)) {
                L.d("You have already installed crash tool, doing nothing!");
                return;
            }
            if (oldHandler != null && !oldHandler.getClass().getName().startsWith("com.android.internal.os")) {
                L.d("IMPORTANT WARNING! You already have an UncaughtExceptionHandler, are you sure this is correct? If you use ACRA, Crashlytics or similar libraries, you must initialize them AFTER this crash tool! Installing anyway, but your original handler will not be called.");
            }

            //We define a default exception handler that does what we want so it can be called from Crashlytics/ACRA
            Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
            L.d("Crash tool has been installed.");
        } catch (Throwable t) {
            L.e("An unknown error occurred while installing crash tool, it may not have been properly initialized. Please report this as a bug if needed.", t);
        }
    }

    /**
     * 获取崩溃异常日志
     */
    private static String getDeviceInfo() {
        StringBuilder builder = new StringBuilder();
        PackageInfo pi = getPackageInfo();
        String dateTime = DateFormat.getDateTimeInstance().format(Calendar.getInstance(Locale.getDefault()).getTime());
        String appName = pi.applicationInfo.loadLabel(application.getPackageManager()).toString();
        int[] pixels = getPixels();
        String cpu;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cpu = Arrays.deepToString(Build.SUPPORTED_ABIS);
        } else {
            cpu = Build.CPU_ABI;
        }
        builder.append("Date Time: ").append(dateTime).append("\n");
        builder.append("App Version: ").append(appName).append(" v").append(pi.versionName).append("(").append(pi.versionCode).append(")\n");
        builder.append("Android OS: ").append(Build.VERSION.RELEASE).append("(").append(cpu).append(")\n");
        builder.append("Phone Model: ").append(getDeviceModelName()).append("\n");
        builder.append("Screen Pixel: ").append(pixels[0]).append("x").append(pixels[1]).append(",").append(pixels[2]).append("\n\n");
        return builder.toString();
    }

    /**
     * 获取App安装包信息
     */
    private static PackageInfo getPackageInfo() {
        PackageInfo info = null;
        try {
            info = application.getPackageManager().getPackageInfo(application.getPackageName(), 0);
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
        if (info == null) {
            info = new PackageInfo();
        }
        return info;
    }

    /**
     * 获取屏幕宽高像素
     */
    private static int[] getPixels() {
        int[] pixels = new int[3];
        DisplayMetrics dm = new DisplayMetrics();
        WindowManager windowMgr = (WindowManager) application.getSystemService(Context.WINDOW_SERVICE);
        windowMgr.getDefaultDisplay().getMetrics(dm);
        pixels[0] = dm.widthPixels;
        pixels[1] = dm.heightPixels;
        pixels[2] = dm.densityDpi;
        return pixels;// e.g. 1080,1920,480
    }

    /**
     * INTERNAL method that returns the device model name with correct capitalization.
     * Taken from: http://stackoverflow.com/a/12707479/1254846
     *
     * @return The device model name (i.e., "LGE Nexus 5")
     */
    private static String getDeviceModelName() {
        String manufacturer = Build.MANUFACTURER;
        String model = Build.MODEL;
        if (model.startsWith(manufacturer)) {
            return capitalize(model);
        } else {
            return capitalize(manufacturer) + " " + model;
        }
    }

    /**
     * INTERNAL method that capitalizes the first character of a string
     *
     * @param s The string to capitalize
     * @return The capitalized string
     */
    private static String capitalize(String s) {
        if (s == null || s.length() == 0) {
            return "";
        }
        char first = s.charAt(0);
        if (Character.isUpperCase(first)) {
            return s;
        } else {
            return Character.toUpperCase(first) + s.substring(1);
        }
    }

    /**
     * INTERNAL method that kills the current process.
     * It is used after restarting or killing the app.
     */
    private static void killCurrentProcess() {
        android.os.Process.killProcess(android.os.Process.myPid());
        System.exit(10);
    }

    private static String toStackTraceString(Throwable throwable) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        throwable.printStackTrace(pw);
        String stackTraceString = sw.toString();

        //Reduce data to 128KB so we don't get a TransactionTooLargeException when sending the intent.
        //The limit is 1MB on Android but some devices seem to have it lower.
        //See: http://developer.android.com/reference/android/os/TransactionTooLargeException.html
        //And: http://stackoverflow.com/questions/11451393/what-to-do-on-transactiontoolargeexception#comment46697371_12809171
        if (stackTraceString.length() > MAX_STACK_TRACE_SIZE) {
            String disclaimer = " [stack trace too large]";
            stackTraceString = stackTraceString.substring(0, MAX_STACK_TRACE_SIZE - disclaimer.length()) + disclaimer;
        }
        return stackTraceString;
    }

    private static class MyUncaughtExceptionHandler implements Thread.UncaughtExceptionHandler {

        @Override
        public void uncaughtException(Thread thread, final Throwable throwable) {
            L.e("App has crashed, executing UncaughtExceptionHandler", throwable);
            if (L.isDebug()) {
                Toast.makeText(application, "App has crashed", Toast.LENGTH_LONG).show();
            }
            if (!Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
                L.d("External storage unmounted");
                return;
            }
            //noinspection Convert2Lambda
            Executors.newSingleThreadExecutor().execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        File externalCacheDir = application.getExternalCacheDir();
                        if (externalCacheDir == null) {
                            L.d("External cache dir is null");
                            return;
                        }
                        File file = new File(externalCacheDir.getAbsolutePath(), "crash.log");
                        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(
                                new FileOutputStream(file)));
                        writer.write(getDeviceInfo() + "\n\n" + toStackTraceString(throwable));
                        writer.close();
                        L.d("Save stack trace: " + file.getAbsolutePath());
                    } catch (Exception e) {
                        L.e("Save stack trace failed", e);
                    }
                }
            });
            killCurrentProcess();
        }

    }

}
