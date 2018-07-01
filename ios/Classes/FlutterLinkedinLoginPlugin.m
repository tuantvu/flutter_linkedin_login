#import "FlutterLinkedinLoginPlugin.h"
#import <flutter_linkedin_login/flutter_linkedin_login-Swift.h>

@implementation FlutterLinkedinLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLinkedinLoginPlugin registerWithRegistrar:registrar];
}
@end
