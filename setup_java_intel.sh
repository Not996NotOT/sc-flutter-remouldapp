#!/bin/bash

echo "=== Intel Mac Java 环境设置脚本 ==="

# 检查Java 11是否安装
if /usr/libexec/java_home -v 11 >/dev/null 2>&1; then
    JAVA_11_HOME=$(/usr/libexec/java_home -v 11)
    echo "✅ 找到Java 11: $JAVA_11_HOME"
    
    # 设置环境变量
    export JAVA_HOME="$JAVA_11_HOME"
    export PATH="$JAVA_HOME/bin:$PATH"
    
    echo "✅ 已设置JAVA_HOME=$JAVA_HOME"
    
    # 验证Java版本
    echo "当前Java版本:"
    java -version
    
    echo ""
    echo "=== 构建步骤 ==="
    echo "1. 清理缓存: rm -rf ~/.gradle/caches/ && flutter clean"
    echo "2. 获取依赖: flutter pub get"
    echo "3. 构建APK: flutter build apk --release"
    echo ""
    echo "如果需要永久设置，请将以下内容添加到 ~/.zshrc 或 ~/.bash_profile:"
    echo "export JAVA_HOME=\"$JAVA_11_HOME\""
    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH\""
    
else
    echo "❌ 未找到Java 11，请先安装Java 11"
    echo "可以使用以下命令安装:"
    echo "brew install openjdk@11"
    echo "或者从Oracle官网下载安装"
fi
