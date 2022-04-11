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
            openNotificationSettings()
            
        case "info":
            getInfo(result: result)
            
        case "badge_update":
            updateBadge(badge: call.arguments as! Int)
            
        case "request_tracking_authorization":
            requestTrackingAuthorization(result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func updateBadge(badge: Int){
        if isSupportedBadge {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
    }

    /*
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
    case notSupported = 4
    */
    private func requestTrackingAuthorization(result: @escaping FlutterResult) {
      if #available(iOS 14, *) {
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
              result(Int(status.rawValue))
          })
      } else {
          // return notSupported
          result(Int(4))
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
            "app_version": appVersion!,
            "app_build": appBuild!,
            "app_name": appName!,
            "app_bundle": appBundle!,
            "is_tablet": isTablet,
            "uuid": uuid!,
            "os_version": systemVersion,
            "manufacturer": manufacturer,
            "brand": brand,
            "model": model,
            "is_miui": false,
            "is_gms": false,
            "is_hms": false,
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
