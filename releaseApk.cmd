@rem 目标平台可选[android-arm (default), android-arm64 (default), android-x86, android-x64]
@rem 截止2019.8.28，Flutter的发布包貌似只支持armeabi-v7a及arm64-v8a
@rem 还不支持x86包构建？报错："android-x86" is not an allowed value for option "target-platform"
@rem 需注意和安卓原生的build.gradle里配置的“ndk.abiFilters”或“splits.abi”冲突
flutter build apk --release --split-per-abi
