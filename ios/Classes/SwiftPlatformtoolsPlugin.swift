import Flutter
import UIKit

public class SwiftPlatformToolsPlugin: NSObject, FlutterPlugin {

    private var isSupportedBadge = false;

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gecegibi/platform_tools", binaryMessenger: registrar.messenger())
        let instance = SwiftPlatformToolsPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "app_settings": fallthrough
        case "app_notification_settings":
            self?.openNotificationSettings()
            
        case "info":
            self?.getInfo(result: result)
            
        case "badge_update":
            self?.updateBadge(badge: call.arguments as! Int)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func updateBadge(badge: Int){
        if isSupportedBadge {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
    }
    
    private func getInfo(result: FlutterResult) {
        
        // Proxy
        let info = Bundle.main.infoDictionary
        
        let appVersion = info?["CFBundleShortVersionString"] as? String
        let appBuild = info?["CFBundleVersion"] as? String
        let appName = info?["CFBundleDisplayName"] as? String
        let appBundle = Bundle.main.bundleIdentifier
        let isTablet = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let systemVersion = UIDevice.current.systemVersion
        let manufacturer = "apple"
        let brand = isTablet ? "iPad" : "iPhone"
        let model = unameMachine
        
        result([
            "appVersion": appVersion!,
            "appBuild": appBuild!,
            "appName": appName!,
            "appBundle": appBundle!,
            "isTablet": isTablet,
            "uuid": uuid!,
            "systemVersion": systemVersion,
            "manufacturer": manufacturer,
            "service": "google",
            "brand": brand,
            "model": model,
            "isMIUI": false
        ])
    }
    
    private func openNotificationSettings(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    var unameMachine: String {
        var utsnameInstance = utsname()
        uname(&utsnameInstance)
        let machine: String? = withUnsafePointer(to: &utsnameInstance.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        return machine ?? "N/A"
    }
}
