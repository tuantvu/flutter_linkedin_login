# flutter_linkedin_login

A Flutter plugin for [Sign in with LinkedIn](https://developer.linkedin.com/docs/signin-with-linkedin)

## Installation
See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_linkedin_login#-installing-tab-)

### Android
Follow the "Associate your Android app with your LinkedIn app" section of LinkedIn's
[Getting started with Android](https://developer.linkedin.com/docs/android-sdk). 
Find your package name in the android/app/src/main/AndroidManifest.xml file.
For the debug key hash value generation, remember to use 'android' as your password.
Click *update* after adding your package and key in 
LinkedIn's developer console for your changes to take.  
  
Open your MainActivity in your Android app/src/main/ directory and override the
onActivityResult method with the following
```kotlin

import android.content.Intent
import io.tuantvu.flutterlinkedinlogin.FlutterLinkedinLoginPlugin

//kotlin
override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
  FlutterLinkedinLoginPlugin.onActivityResult(this, requestCode, resultCode, data)
  super.onActivityResult(requestCode, resultCode, data)
}
```
```java

import android.content.Intent
import io.tuantvu.flutterlinkedinlogin.FlutterLinkedinLoginPlugin

//java
@Override
public void onActivityResult(int requestCode, int resultCode, Intent data) {
  FlutterLinkedinLoginPlugin.onActivityResult(this, requestCode, resultCode, data);
  super.onActivityResult(requestCode, resultCode, data);
}
```

### iOS
Follow the "Associate your iOS app with your LinkedIn app" section of LinkedIn's
[Getting started with iOS](https://developer.linkedin.com/docs/ios-sdk). 
  
Open your AppDelegate in your ios/Runner directory and add the following function
```
//swift
//add #import <flutter_linkedin_login/FlutterLinkedinLoginPlugin.h>
//to your Running-Bridging-Header.h file
override func application(_ app: UIApplication, open: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if (FlutterLinkedinLoginPlugin.shouldHandle(open)) {
        return FlutterLinkedinLoginPlugin.application(app, open: open, sourceApplication: nil, annotation: nil)
    }
    return true
}
```
```objectivec
//objective-c
//add #import <flutter_linkedin_login/FlutterLinkedinLoginPlugin.h> at top of your AppDelegate.m
- (BOOL)application:(UIApplication *)application open:(NSURL *)open options:(UIApplicationOpenURLOptionsKey *)options {
    if ([FlutterLinkedinLoginPlugin shouldHandleUrl:url]) {
        return [FlutterLinkedinLoginPlugin application:application open:open sourceApplication:nil annotation: nil];
    }
    return YES;
}
```
## Usage
See the [example](https://pub.dartlang.org/packages/flutter_linkedin_login#-example-tab-)

### Methods
Method | Description | Returns    
------ | ----------- | -------    
loginBasic() | Log in with basic profile | "Logged in" or "Access token still valid"
getProfile() | Retrieves profile with whatever permissions were asked for during log in | LinkedInProfile         
loginBasicWithProfile() | Convenience method that logs in with basic profile and returns the profile | LinkedInProfile
logout() | Logs out | "Cleared session" or "No session"

### Widgets
Widget | Description | Render
------ | ----------- | ------
LinkedInSignInButton | Button that calls loginBasicWithProfile(). To get the profile, pass in argument `onSignIn: (profile, ex){...}` | ![Sign In with LinkedIn](./images/linkedin-button.png)

### LinkedInProfile
```dart
  String firstName;
  String lastName;
  String headline;
  String id;
  String pictureUrl;
  String summary;
  String industry;
  String emailAddress;
  String formattedName;
  LinkedInLocation location;
  List<LinkedInPosition> positions;
```

### Additional API calls
Submit an issue if you would like to see additional LinkedIn APIs exposed. This
simple implementation was enough for my purposes.