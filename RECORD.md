-- 切换旧的版本
echo 'export PATH="/Users/zhangxing/fvm/default/bin:$PATH"' >> ~/.zshrc

echo 'export PATH="/Users/zhangxing/flutter-2.5.0/bin:$PATH"' >> ~/.zshrc

-- adb安装
adb install -r build/app/outputs/flutter-apk/app-release.apk