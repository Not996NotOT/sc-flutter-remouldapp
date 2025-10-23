import UIKit
import Flutter
import UMCommon

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        let apmConfig = UMAPMConfig.default()
        apmConfig.crashAndBlockMonitorEnable = true
        apmConfig.launchMonitorEnable = true
        apmConfig.networkEnable = true
        UMCrashConfigure.setAPMConfig(apmConfig)
        
        UMConfigure.initWithAppkey("667a7a7c940d5a4c4976eafd", channel: "青桐智盒/ios")
        UMConfigure.setLogEnabled(true);
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
