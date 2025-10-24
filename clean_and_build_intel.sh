#!/bin/bash

echo "=== Intel Mac Flutter 构建脚本 ==="
echo "解决Java版本冲突和Gradle缓存问题"
echo ""

# 检查Java 11
if /usr/libexec/java_home -v 11 >/dev/null 2>&1; then
    JAVA_11_HOME=$(/usr/libexec/java_home -v 11)
    echo "✅ 找到Java 11: $JAVA_11_HOME"
else
    echo "❌ 未找到Java 11，请先安装"
    echo "安装命令: brew install openjdk@11"
    exit 1
fi

# 设置Java 11环境
export JAVA_HOME="$JAVA_11_HOME"
export PATH="$JAVA_HOME/bin:$PATH"

echo "🔧 当前Java版本:"
java -version
echo ""

echo "🧹 步骤1: 彻底清理所有缓存..."

# 停止所有Gradle进程
echo "停止Gradle守护进程..."
pkill -f gradle 2>/dev/null || true
pkill -f daemon 2>/dev/null || true

# 删除Gradle缓存
echo "删除Gradle缓存..."
rm -rf ~/.gradle/caches/
rm -rf ~/.gradle/daemon/
rm -rf ~/.gradle/wrapper/

# 删除Android缓存
echo "删除Android缓存..."
rm -rf ~/.android/build-cache/

# 清理项目缓存
echo "清理项目缓存..."
flutter clean
rm -rf android/.gradle/
rm -rf android/build/
rm -rf android/app/build/
rm -rf build/

echo ""
echo "🔄 步骤2: 重新获取依赖..."
flutter pub get

echo ""
echo "🏗️ 步骤3: 构建APK..."
echo "使用Java 11构建..."

# 强制使用Java 11构建
JAVA_HOME="$JAVA_11_HOME" flutter build apk --release --verbose

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 构建成功！"
    echo "APK位置: build/app/outputs/flutter-apk/app-release.apk"
else
    echo ""
    echo "❌ 构建失败，请检查错误信息"
    echo ""
    echo "🔧 故障排除:"
    echo "1. 确保Java 11正确安装"
    echo "2. 检查网络连接"
    echo "3. 重新运行此脚本"
    exit 1
fi
