@REM 目标平台可选[android-arm (default), android-arm64 (default), android-x86, android-x64]
@REM 截止2019.8.28，Flutter的发布包貌似只支持armeabi-v7a及arm64-v8a
@REM 还不支持x86包构建？报错："android-x86" is not an allowed value for option "target-platform".
@REM 还不支持x64包构建？报错："android-x64" is not an allowed value for option "target-platform".
@rem 需注意和安卓原生的build.gradle里配置的“ndk.abiFilters”或“splits.abi”冲突

flutter clean
flutter build apk --verbose --profile --no-pub --no-track-widget-creation --build-name=1.0.0-dev+201909120913 --build-number=20190912 --split-per-abi --target-platform android-arm
