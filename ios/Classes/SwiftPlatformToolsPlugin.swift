import AppTrackingTransparency
import Flutter
import UIKit

public class SwiftPlatformToolsPlugin: NSObject, FlutterPlugin {
    
    private var isSupportedBadge = false;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gecegibi/platform_tools", binaryMessenger: registrar.messenger())
        let instance = SwiftPlatformToolsPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: .badge)
        { (granted, error) in
            self.isSupportedBadge = error == nil
        }
    }
    
    //    public func applicationWillTerminate(_ application: UIApplication) {
    //        debugPrint("applicationWillTerminate")
    //    }
    
    //    public func applicationWillResignActive(_ application: UIApplication) {
    //        debugPrint("applicationWillResignActive")
    //    }
    
    //    public func applicationDidEnterBackground(_ application: UIApplication) {
    //        debugPrint("applicationDidEnterBackground")
    //    }
    
    //    public func applicationWillEnterForeground(_ application: UIApplication) {
    //        print("applicationWillEnterForeground")
    //    }
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    result(Int(status.rawValue))
                })
            }
            
        } else {
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
        let manufacturer = "Apple"
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
            "is_emulator": isEmulator,
            "is_miui": false,
            "is_gms": false,
            "is_hms": false,
            "memory_total": ProcessInfo.processInfo.physicalMemory,
            "storage_total": totalDiskSpaceInBytes,
            "storage_free" : freeDiskSpaceInBytes,
        ])
    }
    
    var totalDiskSpaceInBytes:Int64 {
         guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
             let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
         return space
     }
    
    var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
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
    
    var isEmulator: Bool {
        #if TARGET_OS_SIMULATOR
            return false
        #else
            return true
        #endif
    }
}
