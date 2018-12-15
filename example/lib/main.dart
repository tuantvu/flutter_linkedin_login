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
  String _output = 'See output here';
  int navIndex = 0;

  _signInWithLinkedIn() async {
    _callPlatformService(() async {
      String status = await FlutterLinkedinLogin.loginBasic();
      debugPrint("_signInWithLinkedIn: $status");
      setState(() {
        _output = status;
      });
    });
  }

  _getProfile() async {
    _callPlatformService(() async {
      LinkedInProfile profile = await FlutterLinkedinLogin.getProfile();
      debugPrint("profile: $profile");
      setState(() {
        _output = profile.toString();
      });
    });
  }

  _logout() async {
    _callPlatformService(() async {
      String status = await FlutterLinkedinLogin.logout();
      debugPrint("_logout: $status");
      setState(() {
        _output = status;
      });
    });
  }

  _accessToken() async {
    _callPlatformService(() async {
      LinkedInAccessToken accessToken = await FlutterLinkedinLogin.accessToken();
      debugPrint("_accessToken: $accessToken");
      setState(() {
        _output = accessToken.toString();
      });
    });
  }

  _callPlatformService(FutureCallBack callback) async {
    try {
      await callback();
    } on PlatformException catch(e) {
      debugPrint("PlatformException code: ${e.code}, message: ${e.message}, toString: ${e.toString()}");
      setState(() {
        _output = "code: ${e.code}, message: ${e.message}";
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
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.black54,
            currentIndex: navIndex,
            onTap: (index) {
              switch (index) {
                case 0: _signInWithLinkedIn(); break;
                case 1: _getProfile(); break;
                case 2: _accessToken(); break;
                case 3: _logout(); break;
              }
              setState(() {
                navIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              navItem(iconData: Icons.accessibility, title: "Login"),
              navItem(iconData: Icons.person, title: "Profile"),
              navItem(iconData: Icons.vpn_key, title: "Token"),
              navItem(iconData: Icons.exit_to_app, title: "Logout"),
            ]),
        body: Center(
          child: new ListView(
            children: <Widget>[
              new LinkedInSignInButton(onSignIn: (profile, ex) {
                if (profile != null) {
                  debugPrint("profile: $profile");
                  setState(() {
                    _output = profile.firstName;
                  });
                } else {
                  debugPrint("exception: $ex");
                  setState(() {
                    _output = "code: ${ex.code}, message: ${ex.message}";
                  });
                }
              },),
              Divider(height: 4.0,),
              new Text('Output', textAlign: TextAlign.center, textScaleFactor: 1.5,),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text('$_output\n',),
              ),
            ]
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem navItem({IconData iconData, String title}) {
    return BottomNavigationBarItem(
      icon: Icon(iconData, color: Colors.black54,),
        title: Text(title, style: TextStyle(color: Colors.black54),),
    );
  }
}
