import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkedin_login/flutter_linkedin_login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

typedef Future<void> FutureCallBack();

class _MyAppState extends State<MyApp> {
  String _loginStatus = 'Press button to log in';

  _signInWithLinkedIn() async {
    _callPlatformService(() async {
      String status = await FlutterLinkedinLogin.loginBasic();
      setState(() {
        _loginStatus = status;
      });
    });
  }

  _getProfile() async {
    _callPlatformService(() async {
      LinkedInProfile profile = await FlutterLinkedinLogin.getProfile();
      debugPrint("profile: $profile");
      setState(() {
        _loginStatus = profile.firstName;
      });
    });
  }

  _signInWithBasicProfile() async {
    _callPlatformService(() async {
      LinkedInProfile profile = await FlutterLinkedinLogin.loginBasicWithProfile();
      debugPrint("profile: $profile");
      setState(() {
        _loginStatus = profile.firstName;
      });
    });
  }

  _logout() async {
    _callPlatformService(() async {
      String status = await FlutterLinkedinLogin.logout();
      debugPrint("logout status: $status");
      setState(() {
        _loginStatus = status;
      });
    });
  }

  _callPlatformService(FutureCallBack callback) async {
    try {
      await callback();
    } on PlatformException catch(e) {
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
      setState(() {
        _loginStatus = "code: ${e.code}, message: ${e.message}";
      });
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('LinkedIn Login Plugin Example'),
        ),
        body: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text('Login status: $_loginStatus\n'),
              new RaisedButton(
                onPressed: () => _signInWithLinkedIn(),
                child: new Text("Log into LinkedIn"),
              ),
              new LinkedInSignInButton(onSignIn: (profile, ex) {
                if (profile != null) {
                  debugPrint("profile: $profile");
                  setState(() {
                    _loginStatus = profile.firstName;
                  });
                } else {
                  debugPrint("exception: $ex");
                  setState(() {
                    _loginStatus = "code: ${ex.code}, message: ${ex.message}";
                  });
                }
              },),
              new RaisedButton(
                onPressed: _getProfile,
                child: new Text("Get Profile"),
              ),
              new RaisedButton(
                onPressed: _logout,
                child: new Text("Clear Session"),
              )
            ]
          ),
        ),
      ),
    );
  }
}
