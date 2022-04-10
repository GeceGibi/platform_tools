#import "PlatformtoolsPlugin.h"
#if __has_include(<platformtools/platformtools-Swift.h>)
#import <platformtools/platformtools-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "platformtools-Swift.h"
#endif

@implementation PlatformToolsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformToolsPlugin registerWithRegistrar:registrar];
}
@end
