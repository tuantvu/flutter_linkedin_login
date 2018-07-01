# flutter_linkedin_login

A Flutter plugin for [Sign in with LinkedIn](https://developer.linkedin.com/docs/signin-with-linkedin)

*Note*: Only Android is currently supported. iOS support pending

## Installation
See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_linkedin_login#-installing-tab-)

### Android

### iOS
- *Coming Soon*

## Usage
### Signing in
```dart
_signInWithLinkedIn() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    String status = await FlutterLinkedinLogin.login;
  } on PlatformException catch(e) {
    debugPrint("code: ${e.code}, message: ${e.message}");
  }
}
```

### Getting user profiles
- *Coming Soon*