# Intel Mac 构建指南

## 环境要求
- Java 11 (推荐使用Oracle JDK 11.0.18)
- Flutter SDK
- Android SDK

## 快速开始

### 1. 检查Java环境
```bash
# 运行Java环境设置脚本
./setup_java_intel.sh
```

### 2. 构建步骤
```bash
# 切换到intel分支
git checkout intel
git pull origin intel

# 清理缓存 (重要!)
rm -rf ~/.gradle/caches/
flutter clean

# 获取依赖
flutter pub get

# 构建APK
flutter build apk --release
```

## 常见问题

### 问题1: Java版本错误
如果遇到 `Unsupported class file major version` 错误:
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
