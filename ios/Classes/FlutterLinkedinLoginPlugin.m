#import "FlutterLinkedinLoginPlugin.h"
#import <flutter_linkedin_login/flutter_linkedin_login-Swift.h>
#import <linkedin-sdk/LISDK.h>

NSString *const URL = @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,industry,summary,picture-url)?format=json";

@implementation FlutterLinkedinLoginPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  [SwiftFlutterLinkedinLoginPlugin registerWithRegistrar:registrar];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                            methodChannelWithName:@"io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login"
                                            binaryMessenger:registrar.messenger];
    
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%s","In method caller");
        if ([call.method isEqual: @"logIntoLinkedIn"]) {
            [self logIntoLinkedIn:result];
        } else if ([call.method isEqual: @"getProfile"]) {
            [self getProfile:result];
        } else if ([call.method isEqual: @"clearSession"]) {
            [self clearSession:result];
        } else {
            NSLog(@"%s","method not implemented");
            result(FlutterMethodNotImplemented);
        }
        
    }];
}

+ (void)logIntoLinkedIn:(FlutterResult) result {
    NSLog(@"logging into linkedin");
    if ([LISDKSessionManager hasValidSession]) {
        [LISDKSessionManager createSessionWithAccessToken:[LISDKSessionManager sharedInstance].session.accessToken];
        result(@"Access token still valid");
    } else {
        [LISDKSessionManager
         createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil]
         state:nil
         showGoToAppStoreDialog:YES
         successBlock:^(NSString *returnState) {
             NSLog(@"%s","success called!");
             result(@"Logged in");
         }
         errorBlock:^(NSError *error) {
             NSLog(@"error: %@", error.description);
             
             NSString * message;
             NSString * errorCode = [NSString stringWithFormat: @"%ld", (long)error.code];
             for (id key in error.userInfo) {
                 message = key;
             }
             result([FlutterError errorWithCode:errorCode message:message details:nil]);
         }
         ];
    }
}

+ (void)getProfile:(FlutterResult) result {
    NSLog(@"getting profile");
    [[LISDKAPIHelper sharedInstance] getRequest:URL
        success:^(LISDKAPIResponse *response) {
            NSLog(@"data: %@, code: %d", response.data, response.statusCode);
            result(response.data);
        }
        error:^(LISDKAPIError *error) {
            NSLog(@"error: %@", error.description);
            NSString * message = error.description;
            NSString * errorCode = @"401";
            
            LISDKAPIResponse *response = [error errorResponse];
            if (response) {
                NSLog(@"response: %@", response.data);
                message = response.data;
                errorCode = [NSString stringWithFormat: @"%ld", (long)response.statusCode];
            }
            NSLog(@"errorCode: %s, message: %s", errorCode, message);
            result([FlutterError errorWithCode:errorCode message:message details:error.description]);
        }];
}

+ (void)clearSession:(FlutterResult) result {
    NSLog(@"clearing session");
    if ([LISDKSessionManager hasValidSession]) {
        [LISDKSessionManager clearSession];
        result(@"Cleared session");
    } else {
        result(@"No session");
    }
}

//Handles openURL callback to this app when LinkedIn App returns any response to this app
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%s","onOpenURL called!");
    
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

@end
