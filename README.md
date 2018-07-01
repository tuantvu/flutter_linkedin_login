# flutter_linkedin_login

A Flutter plugin for [Sign in with LinkedIn](https://developer.linkedin.com/docs/signin-with-linkedin)

*Note*: Only Android is currently supported. iOS support pending

## Installation
See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_linkedin_login#-installing-tab-)

### Android
Follow the "Associate your Android app with your LinkedIn app" section of LinkedIn's
[Getting started with Android](https://developer.linkedin.com/docs/android-sdk). 
Find your package name in the android/app/src/main/AndroidManifest.xml file.
For the debug key hash value generation, remember to use 'android' as your password.
Click *update* after adding your package and key in 
LinkedIn's developer console for your changes to take.


### iOS
- *Coming Soon*

## Usage
### Signing in
`FlutterLinkedInLogin.login` will check if an access token is still valid on the device. If not,
then it will proceed with LinkedIn's sign in process. Login will throw exceptions with code detailed
[here](https://developer.linkedin.com/docs/oauth2). A user can either cancel login or cancel authorization.

```dart
  _signInWithLinkedIn() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String status = await FlutterLinkedinLogin.login;
      debugPrint("login status: $status");
    } on PlatformException catch(e) {
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
    }
  }
```

### Getting LinkedIn Profile
`FlutterLinkedinLogin.profile` will retrieve the user's basic profile which includes their 
LinkedIn id, first name, last name, headline, industry, summary, and pictureUrl. Profile will
communicate errors via http status codes as documented [here](https://developer.linkedin.com/docs/guide/v2/error-handling).

```dart
  _getProfile() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      LinkedInProfile profile = await FlutterLinkedinLogin.profile;
      debugPrint("profile: $profile");
    } on PlatformException catch(e) {
      debugPrint("PlatformException httpStatusCode: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
    }
  }
```

### Clearing session
`FlutterLinkedinLogin.clearSession` clears the users access token, essentially logging them out. 
Even if a token doesn't exist, clearSession will return a success with message 'No session', 
therefore a PlatformException should never be thrown by clearSession.

```dart
  _clearSession() async {
    try {
      String status = await FlutterLinkedinLogin.clearSession;
      debugPrint("logout status: $status");
    } on PlatformException catch(e) { //This should never happen
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
    }
  }
```

### Additional API calls
Submit an issue if you would like to see additional LinkedIn APIs exposed. This
simple implementation was enough for my purposes.