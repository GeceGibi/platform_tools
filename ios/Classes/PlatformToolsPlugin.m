#import "PlatformToolsPlugin.h"

#if __has_include(<platform_tools/platform_tools-Swift.h>)
#import <platform_tools/platform_tools-Swift.h>
#else
#import "platform_tools-Swift.h"
#endif

@implementation PlatformToolsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformToolsPlugin registerWithRegistrar:registrar];
}
@end
