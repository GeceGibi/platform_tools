#import "PlatformToolsPlugin.h"

#if __has_include(<platformtools/platformtools-Swift.h>)
#import <platform_tools/platformtools-Swift.h>
#else
#import "platform_tools-Swift.h"
#endif

@implementation PlatformToolsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformToolsPlugin registerWithRegistrar:registrar];
}
@end
