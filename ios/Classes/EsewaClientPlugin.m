#import "EsewaClientPlugin.h"
#if __has_include(<esewa_client/esewa_client-Swift.h>)
#import <esewa_client/esewa_client-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "esewa_client-Swift.h"
#endif

@implementation EsewaClientPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEsewaClientPlugin registerWithRegistrar:registrar];
}
@end
