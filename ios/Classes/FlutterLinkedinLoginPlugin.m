#import "FlutterLinkedinLoginPlugin.h"
#import <linkedin-sdk/LISDK.h>

NSString *const URL = @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,industry,summary,picture-url)?format=json";

/**
 * FlutterLinkedInLoginPlugin handles login, clearing session, and getting basic user
 * profile from LinkedIn. Clients must override application:openURL in their AppDelegate and
 * pass the parameters to FlutterLinkedInLoginPlugin.application.
 * Method channel name: "io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login".
 * Call methods: "logIntoLinkedIn", "getLinkedInProfile", "clearSession".
 */
@implementation FlutterLinkedinLoginPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  [SwiftFlutterLinkedinLoginPlugin registerWithRegistrar:registrar];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                            methodChannelWithName:@"io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login"
                                            binaryMessenger:registrar.messenger];
    
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        //NSLog(@"%s","In method caller");
        if ([call.method isEqual: @"logIntoLinkedIn"]) {
            [self logIntoLinkedIn:result];
        } else if ([call.method isEqual: @"getProfile"]) {
            [self getProfile:result];
        } else if ([call.method isEqual: @"clearSession"]) {
            [self clearSession:result];
        } else {
            //NSLog(@"%s","method not implemented");
            result(FlutterMethodNotImplemented);
        }
        
    }];
}

/**
 * Checks to see if the access token is still valid. If so, inits the session with
 * the token. If not, then starts the login process
 */
+ (void)logIntoLinkedIn:(FlutterResult) result {
    //NSLog(@"logging into linkedin");
    if ([LISDKSessionManager hasValidSession]) {
        [LISDKSessionManager createSessionWithAccessToken:[LISDKSessionManager sharedInstance].session.accessToken];
        result(@"Access token still valid");
    } else {
        [LISDKSessionManager
         createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil]
         state:nil
         showGoToAppStoreDialog:YES
         successBlock:^(NSString *returnState) {
             //NSLog(@"%s","success called!");
             result(@"Logged in");
         }
         errorBlock:^(NSError *error) {
             NSLog(@"error: %@", error.description);
             
             NSString * message = error.userInfo[@"errorDescription"];
             NSString * errorCode = error.userInfo[@"errorInfo"];
             result([FlutterError errorWithCode:errorCode message:message details:nil]);
         }
         ];
    }
}

/**
 * Gets basic profile
 */
+ (void)getProfile:(FlutterResult) result {
    //NSLog(@"getting profile");
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] getRequest:URL
            success:^(LISDKAPIResponse *response) {
                //NSLog(@"data: %@, code: %d", response.data, response.statusCode);
                result(response.data);
            }
              error:^(LISDKAPIError *error) {
                  NSLog(@"error: %@", error.description);
                  NSString * message = error.description;
                  NSString * errorCode = @"401";
                  
                  LISDKAPIResponse *response = [error errorResponse];
                  if (response) {
                      //NSLog(@"response: %@", response.data);
                      message = response.data;
                      errorCode = [NSString stringWithFormat: @"%ld", (long)response.statusCode];
                  }
                  //NSLog(@"errorCode: %s, message: %s", errorCode, message);
                  result([FlutterError errorWithCode:errorCode message:message details:error.description]);
              }];
    } else {
        result([FlutterError errorWithCode:@"401" message:@"access token is not set" details:nil]);
    }
    
}

/**
 * Clears the access token from session
 */
+ (void)clearSession:(FlutterResult) result {
    //NSLog(@"clearing session");
    if ([LISDKSessionManager hasValidSession]) {
        [LISDKSessionManager clearSession];
        result(@"Cleared session");
    } else {
        result(@"No session");
    }
}

/**
 * Handles application(...openURL) callback to this app when LinkedIn App returns any response to this app
 */
+ (BOOL)shouldHandleUrl:(NSURL *)url {
    return [LISDKCallbackHandler shouldHandleUrl:url];
}

/**
 * Handles application(...openURL) callback to this app when LinkedIn App returns any response to this app
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //NSLog(@"%s","onOpenURL called!");
    
    return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

}

@end
