package com.njguochu.qingtongzhihe;
import android.os.Bundle;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import com.jarvan.fluwx.handlers.FluwxRequestHandler;
import com.jarvan.fluwx.handlers.WXAPiHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.umeng.umcrash.UMCrash;
import com.umeng.commonsdk.UMConfigure;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        Bundle bundle = new Bundle();
        // 重点关注：如果您还想采集Native 崩溃、ANR等日志可以参考下面设置
        bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_JAVA, true);
        bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_NATIVE, true);
        bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_UNEXP, true);
        bundle.putBoolean(UMCrash.KEY_ENABLE_ANR, false);
        bundle.putBoolean(UMCrash.KEY_ENABLE_PA, false);
        bundle.putBoolean(UMCrash.KEY_ENABLE_LAUNCH, false);
        bundle.putBoolean(UMCrash.KEY_ENABLE_MEM, false);
        bundle.putBoolean(UMCrash.KEY_ENABLE_H5PAGE, false);
        bundle.putBoolean(UMCrash.KEY_ENABLE_POWER, false);
        WXAPiHandler.INSTANCE.setupWxApi("wx01962cc4ae161f91",this,true);
        //Get Ext-Info from Intent.
        FluwxRequestHandler.INSTANCE.handleRequestInfoFromIntent(getIntent());

        UMCrash.initConfig(bundle);
        // 开启模块开关，上述模块开关一定要在init前调用。
        UMConfigure.preInit(getApplicationContext(), "667a7a43cac2a664de54b001", "青桐智盒/android");

    }
}
