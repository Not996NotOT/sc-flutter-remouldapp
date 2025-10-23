-keep class com.shockwave.**
-keepclassmembers class com.shockwave.** { *; }

# 腾讯TRTC SDK相关规则
-keep class com.tencent.** { *; }
-keepclassmembers class com.tencent.** { *; }
-dontwarn com.tencent.**

# TRTC Flutter插件相关
-keep class top.huic.tencent_trtc_cloud.** { *; }
-keepclassmembers class top.huic.tencent_trtc_cloud.** { *; }

