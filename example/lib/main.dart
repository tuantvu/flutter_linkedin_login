import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkedin_login/flutter_linkedin_login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _loginStatus = 'Press button to log in';


  _signInWithLinkedIn() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String status = await FlutterLinkedinLogin.login;
      setState(() {
        _loginStatus = status;
      });
    } on PlatformException catch(e) {
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
      setState(() {
        _loginStatus = "code: ${e.code}, message: ${e.message}";
      });
    }
  }

  _getProfile() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      LinkedInProfile profile = await FlutterLinkedinLogin.profile;
      debugPrint("profile: $profile");
      setState(() {
        _loginStatus = profile.firstName;
      });
    } on PlatformException catch(e) {
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
      setState(() {
        _loginStatus = "code: ${e.code}, message: ${e.message}";
      });
    }
  }

  _clearSession() async {
    try {
      String status = await FlutterLinkedinLogin.clearSession;
      debugPrint("logout status: $status");
      setState(() {
        _loginStatus = status;
      });
    } on PlatformException catch(e) {
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
      setState(() {
        _loginStatus = "code: ${e.code}, message: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('LinkedIn Login Plugin Example'),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('Login status: $_loginStatus\n'),
            new RaisedButton(
              onPressed: _signInWithLinkedIn,
              child: new Text("Log into LinkedIn"),
            ),
            new RaisedButton(
              onPressed: _getProfile,
              child: new Text("Get Profile"),
            ),
            new RaisedButton(
              onPressed: _clearSession,
              child: new Text("Clear Session"),
            )
          ]
        ),
      ),
    );
  }
}
