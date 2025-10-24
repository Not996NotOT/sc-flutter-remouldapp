# Intel Mac 构建指南

## 问题说明
Intel Mac上可能存在Java版本冲突问题：
- 系统可能有多个Java版本（Java 11, 17, 21, 23等）
- Gradle缓存可能被高版本Java污染（major version 65错误）
- Flutter 2.5.0需要使用兼容的Gradle版本
- 需要彻底清理缓存并使用专用Gradle目录

## 环境要求
- Java 11 (必须！推荐使用Oracle JDK 11.0.18)
- Flutter SDK
- Android SDK

## 🚀 一键构建（推荐）

### 方案A：常规构建
```bash
# 切换到intel分支
git checkout intel
git pull origin intel

# 运行一键构建脚本
./clean_and_build_intel.sh
```

### 方案B：强制清理构建（如果方案A失败）
```bash
# 强制清理所有缓存并构建
./force_clean_intel.sh
```

**注意**: 方案B会要求sudo权限来彻底清理系统缓存

## 📋 手动构建步骤

### 1. 安装Java 11
```bash
# 如果没有Java 11，先安装
brew install openjdk@11

# 验证安装
/usr/libexec/java_home -v 11
```

### 2. 彻底清理缓存
```bash
# 停止所有Gradle进程
pkill -f gradle
pkill -f daemon

# 删除所有Gradle缓存
rm -rf ~/.gradle/caches/
rm -rf ~/.gradle/daemon/
rm -rf ~/.gradle/wrapper/

# 删除Android缓存
rm -rf ~/.android/build-cache/

# 清理项目缓存
flutter clean
rm -rf android/.gradle/
rm -rf android/build/
rm -rf android/app/build/
```

### 3. 设置Java 11环境
```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export PATH="$JAVA_HOME/bin:$PATH"

# 验证Java版本
java -version
# 应该显示: java version "11.0.x"
```

### 4. 构建APK
```bash
# 获取依赖
flutter pub get

# 构建APK
JAVA_HOME=$(/usr/libexec/java_home -v 11) flutter build apk --release
```

## 常见问题

### 问题1: major version 65错误（最常见）
如果遇到 `Unsupported class file major version 65` 错误：

**原因**: Gradle缓存被Java 21污染，Flutter工具仍使用系统默认Gradle目录

**解决方案（按顺序尝试）**:

**方案1**: 使用强制清理脚本
```bash
./force_clean_intel.sh
```

**方案2**: 手动彻底清理
```bash
# 停止所有Java进程
sudo pkill -9 -f java
sudo pkill -9 -f gradle

# 删除所有Gradle缓存
sudo rm -rf ~/.gradle/
sudo rm -rf /tmp/.gradle*
sudo rm -rf /var/tmp/.gradle*

# 重新构建
./clean_and_build_intel.sh
```

**方案3**: 直接使用Gradle构建
```bash
cd android
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
./gradlew clean
./gradlew assembleRelease --no-daemon
```

### 问题2: Java版本错误
如果遇到其他 `Unsupported class file major version` 错误:
```bash
# 确保使用Java 11
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export PATH="$JAVA_HOME/bin:$PATH"
```

### 问题2: Gradle缓存问题
如果构建失败:
```bash
# 清理所有缓存
rm -rf ~/.gradle/
rm -rf android/.gradle/
rm -rf android/build/
flutter clean
```

### 问题3: 插件兼容性警告
项目中的一些插件使用了旧版Android嵌入，这是警告不是错误，不影响构建。

## 版本信息
- Gradle: 8.4
- Android Gradle Plugin: 8.1.2
- Kotlin: 1.9.10
- Compile SDK: 34
- Target SDK: 34
- Java兼容性: 1.8 (运行时使用Java 11)

## 技术支持
如果遇到问题，请检查:
1. Java版本是否为11
2. 是否清理了所有缓存
3. 网络连接是否正常
