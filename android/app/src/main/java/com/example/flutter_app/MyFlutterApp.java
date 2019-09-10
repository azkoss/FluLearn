package com.example.flutter_app;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.CallSuper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;
import java.util.Stack;

import io.flutter.app.FlutterApplication;

/**
 * Flutter APP
 *
 * @author liyujiang
 * @see AppLifecycleCallback
 */
public class MyFlutterApp extends FlutterApplication {
    public static final String LOG_TAG = "flutterApp";
    private static final AppLifecycleCallback LIFECYCLE_CALLBACK = new AppLifecycleCallback();
    private static Stack<Activity> activityStack = new Stack<>();
    private static Application application;

    @Override
    public void onCreate() {
        super.onCreate();
        android.util.Log.w(LOG_TAG, "Android native load finished");
        initInApplication(this);
    }

    private static void initInApplication(Application app) {
        if (application != null && app.getClass() != application.getClass()) {
            application.unregisterActivityLifecycleCallbacks(LIFECYCLE_CALLBACK);
        }
        application = app;
        //注册生命周期监听器
        application.registerActivityLifecycleCallbacks(LIFECYCLE_CALLBACK);
    }

    /**
     * 检查是否继承或调用了{@link #initInApplication}
     */
    private static void checkApplicationNotNull() {
        if (application == null) {
            String name = MyFlutterApp.class.getName();
            throw new RuntimeException("Please call [" + name + "] in your Application");
        }
    }

    @SuppressWarnings("unused")
    public static synchronized Context getAppContext() {
        checkApplicationNotNull();
        return application.getApplicationContext();
    }

    /**
     * 退出APP
     *
     * @param forceKill 是否强制杀死进程
     */
    public static void exitApp(boolean forceKill) {
        while (!activityStack.isEmpty()) {
            activityStack.pop().finish();
        }
        clearAllActivityTask();
        if (forceKill) {
            android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(0);
        }
    }

    /**
     * 清除最近任务记录，以便在按任务键看不到任何活动的界面（效果类似于android:excludeFromRecents="true"）
     */
    private static void clearAllActivityTask() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return;
        }
        checkApplicationNotNull();
        ActivityManager am = (ActivityManager) application.getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) {
            return;
        }
        try {
            List<ActivityManager.AppTask> appTasks = am.getAppTasks();
            for (ActivityManager.AppTask appTask : appTasks) {
                android.util.Log.d(LOG_TAG, "will finish and remove task: id=" + appTask.getTaskInfo().id);
                appTask.finishAndRemoveTask();
            }
        } catch (SecurityException e) {
            android.util.Log.w(LOG_TAG, "", e);
        }
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

    /**
     * 简单的Activity及Fragment生命周期监听
     */
    public static class AppLifecycleCallback extends FragmentManager.FragmentLifecycleCallbacks
            implements Application.ActivityLifecycleCallbacks {
        private FragmentManager fragmentManager;

        @CallSuper
        @Override
        public void onActivityCreated(Activity activity, Bundle bundle) {
            android.util.Log.d(LOG_TAG, "onActivityCreated " + activity.getClass().getName());
            activityStack.addElement(activity);
            if (activity instanceof FragmentActivity) {
                fragmentManager = ((FragmentActivity) activity).getSupportFragmentManager();
                fragmentManager.registerFragmentLifecycleCallbacks(this, false);
            }
        }

        @CallSuper
        @Override
        public void onActivityStarted(Activity activity) {
            android.util.Log.d(LOG_TAG, "onActivityStarted " + activity.getClass().getName());
        }

        @CallSuper
        @Override
        public void onActivityResumed(Activity activity) {
            android.util.Log.d(LOG_TAG, "onActivityResumed " + activity.getClass().getName());
        }

        @CallSuper
        @Override
        public void onActivityPaused(Activity activity) {
            android.util.Log.d(LOG_TAG, "onActivityPaused " + activity.getClass().getName());
        }

        @CallSuper
        @Override
        public void onActivityStopped(Activity activity) {
            android.util.Log.d(LOG_TAG, "onActivityStopped " + activity.getClass().getName());
        }

        @CallSuper
        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
            android.util.Log.d(LOG_TAG, "onActivitySaveInstanceState " + activity.getClass().getName());
        }

        @CallSuper
        @Override
        public void onActivityDestroyed(Activity activity) {
            android.util.Log.d(LOG_TAG, "onActivityDestroyed " + activity.getClass().getName());
            activityStack.removeElement(activity);
            if (fragmentManager != null) {
                fragmentManager.unregisterFragmentLifecycleCallbacks(this);
            }
        }

        @CallSuper
        @Override
        public void onFragmentPreAttached(@NonNull FragmentManager fm, @NonNull Fragment f,
                                          @NonNull Context context) {
            android.util.Log.d(LOG_TAG, "onFragmentPreAttached " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentAttached(@NonNull FragmentManager fm, @NonNull Fragment f,
                                       @NonNull Context context) {
            android.util.Log.d(LOG_TAG, "onFragmentAttached " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentPreCreated(@NonNull FragmentManager fm, @NonNull Fragment f,
                                         @Nullable Bundle savedInstanceState) {
            android.util.Log.d(LOG_TAG, "onFragmentPreCreated " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentCreated(@NonNull FragmentManager fm, @NonNull Fragment f,
                                      @Nullable Bundle savedInstanceState) {
            android.util.Log.d(LOG_TAG, "onFragmentCreated " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentActivityCreated(@NonNull FragmentManager fm, @NonNull Fragment f,
                                              @Nullable Bundle savedInstanceState) {
            android.util.Log.d(LOG_TAG, "onFragmentActivityCreated " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentViewCreated(@NonNull FragmentManager fm, @NonNull Fragment f,
                                          @NonNull View v, @Nullable Bundle savedInstanceState) {
            android.util.Log.d(LOG_TAG, "onFragmentViewCreated " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentStarted(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentStarted " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentResumed(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentResumed " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentPaused(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentPaused " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentStopped(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentStopped " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentSaveInstanceState(@NonNull FragmentManager fm, @NonNull Fragment f, @NonNull Bundle outState) {
            android.util.Log.d(LOG_TAG, "onFragmentSaveInstanceState " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentViewDestroyed(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentViewDestroyed " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentDestroyed(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentDestroyed " + f.getClass().getName());
        }

        @CallSuper
        @Override
        public void onFragmentDetached(@NonNull FragmentManager fm, @NonNull Fragment f) {
            android.util.Log.d(LOG_TAG, "onFragmentDetached " + f.getClass().getName());
        }

    }

}
