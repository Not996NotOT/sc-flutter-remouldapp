#!/bin/bash

echo "=== 强制清理Intel Mac构建环境 ==="
echo "彻底解决major version 65问题"
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

echo ""
echo "🔥 步骤1: 强制清理所有Gradle相关内容..."

# 强制杀死所有相关进程
echo "强制停止所有Java/Gradle进程..."
sudo pkill -9 -f java 2>/dev/null || true
sudo pkill -9 -f gradle 2>/dev/null || true
sudo pkill -9 -f daemon 2>/dev/null || true
sleep 3

# 删除所有可能的Gradle目录
echo "删除所有Gradle缓存..."
sudo rm -rf ~/.gradle/ 2>/dev/null || true
sudo rm -rf ~/.gradle_java11/ 2>/dev/null || true
sudo rm -rf /tmp/.gradle* 2>/dev/null || true
sudo rm -rf /var/tmp/.gradle* 2>/dev/null || true
sudo rm -rf /Users/*/Library/Caches/Gradle/ 2>/dev/null || true

# 删除Android相关缓存
echo "删除Android缓存..."
rm -rf ~/.android/ 2>/dev/null || true

# 清理项目缓存
echo "清理项目缓存..."
flutter clean
rm -rf android/.gradle/ 2>/dev/null || true
rm -rf android/build/ 2>/dev/null || true
rm -rf android/app/build/ 2>/dev/null || true
rm -rf build/ 2>/dev/null || true

# 删除Gradle Wrapper
echo "重置Gradle Wrapper..."
rm -rf android/gradle/wrapper/gradle-wrapper.jar 2>/dev/null || true

echo ""
echo "🔧 步骤2: 创建临时Gradle配置..."

# 创建临时的gradle.properties强制使用Java 11
cat > android/gradle.properties << EOF
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=false
org.gradle.daemon=false
android.useAndroidX=true
android.enableJetifier=true
org.gradle.java.home=$JAVA_11_HOME
EOF

echo "已创建强制Java 11配置"

echo ""
echo "🔄 步骤3: 重新获取依赖..."
export JAVA_HOME="$JAVA_11_HOME"
export PATH="$JAVA_HOME/bin:$PATH"
flutter pub get

echo ""
echo "🏗️ 步骤4: 直接使用Gradle构建..."
echo "跳过Flutter工具，直接调用Gradle"

cd android

# 设置环境变量
export JAVA_HOME="$JAVA_11_HOME"
export PATH="$JAVA_HOME/bin:$PATH"
export GRADLE_OPTS="-Dorg.gradle.java.home=$JAVA_11_HOME -Xmx2048m"

# 验证Java版本
echo "当前Java版本:"
java -version

echo ""
echo "开始Gradle构建..."
./gradlew clean
./gradlew assembleRelease --no-daemon --no-parallel --stacktrace

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 构建成功！"
    echo "APK位置: build/app/outputs/flutter-apk/"
    ls -la build/app/outputs/flutter-apk/
else
    echo ""
    echo "❌ 构建失败"
    echo ""
    echo "🔧 尝试备用方案..."
    echo "使用Flutter工具构建..."
    cd ..
    JAVA_HOME="$JAVA_11_HOME" flutter build apk --release --no-tree-shake-icons
fi
