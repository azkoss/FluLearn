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
问题参见 https://github.com/flutter/flutter/issues/27254 。这是多个安卓模块依赖的androidx版本冲突导致的，解决办法：
根据报错，在安卓原生项目的根部build.gradle里加入以下类似的规则：
subprojects {
    project.configurations.all {
        //此处可用于解决依赖冲突问题，参阅 https://developer.android.google.cn/studio/build/dependencies#duplicate_classes
        resolutionStrategy.eachDependency { details ->
            // Flutter混合开发问题参阅 https://github.com/flutter/flutter/issues/27254
            if (details.requested.group == 'com.android.support'
                    && !details.requested.name.contains('multidex')) {
                details.useVersion "28.0.0"
            } else if (details.requested.group == 'androidx.core') {
                details.useVersion "1.0.2"
            } else if (details.requested.group == 'androidx.appcompat') {
                details.useVersion "1.0.2"
            } else if (details.requested.group == 'androidx.arch.core') {
                details.useVersion "2.0.0"
            } else if (details.requested.group == 'androidx.versionedparcelable') {
                details.useVersion "1.1.0"
            } else if (details.requested.group == 'androidx.vectordrawable') {
                details.useVersion "1.0.0"
            }
        }
    }

    project.evaluationDependsOn(':app')
}
```


