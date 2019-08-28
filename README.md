# flutter_app

安卓 Native+Flutter 应用开发实战


## Getting Started

- [第三方共享包检索](https://pub.dev/flutter)
- [Flutter开发环境搭建](https://flutter.dev/docs/get-started/install)
- [Flutter API手册](https://api.flutter.dev/)
- [电子书《Flutter实战》](https://book.flutterchina.club)


## 踩坑记录

- 在Android Studio中准备好Dart & Flutter插件及SDK后，无法连接模拟器。
```
因为Android SDK的位置不是默认的C:\Users\Administrator\AppData\Local\Android\Sdk导致的，新增系统环境变量“ANDROID_HOME”指向自己的Android SDK的位置，在系统环境变量“Path”增加“%ANDROID_HOME%\platform-tools”，重启Android Studio即可。
```


- 运行提示“Android dependency 'androidx...' has different version for the compile...”。
```
这是多个安卓模块依赖的androidx版本冲突导致的，问题讨论参见 https://github.com/flutter/flutter/issues/27254#issuecomment-525616582
#############################
解决办法一：
#############################
Upgrade Android Gradle Plugin and Gradle to the latest version can solve this problem. For Android Studio 3.5, modify these:

android/build.gradle:
com.android.tools.build:gradle:3.5.0

android/gradle/wrapper/gradle-wrapper.properties:
distributionUrl=https\://services.gradle.org/distributions/gradle-5.4.1-all.zip
#############################
解决办法二：
#############################
Of course, you should manually set the same version via DependencyResolution. So, the following resolution strategy can also be used to resolve the conflicts of dependency :

android/gradle.properties:
androidxCoreVersion=1.0.0
androidxLifecycleVersion=2.0.0

android/build.gradle:
subprojects {
    project.configurations.all {
        resolutionStrategy {
            force "androidx.core:core:${androidxCoreVersion}"
            force "androidx.lifecycle:lifecycle-common:${androidxLifecycleVersion}"
        }
    }
}
```


- 构建正式包报错提示`Conflicting configuration : '...' in ndk abiFilters cannot be present when splits abi filters are set : ...`
```
这是因为使用带“--split-per-abi”参数（如flutter build apk --release --split-per-abi --target-platform android-arm）的构建命令和安卓原生的build.gradle里配置的“ndk.abiFilters”或“splits.abi”冲突，删掉“ndk.abiFilters”或“splits.abi”节点即可。
目测截止2019.8.28，Flutter的发布包貌似只支持armeabi-v7a及arm64-v8a，使用“--target-platform android-x86”参数构建会报错"android-x86" is not an allowed value for option "target-platform"。
```


