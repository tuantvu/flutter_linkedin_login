import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLinkedinLogin {
  static const MethodChannel _channel =
      const MethodChannel('io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login');

  static Future<String> get login async {
    return await _channel.invokeMethod('logIntoLinkedIn');
  }

  static Future<String> get profile async {
    return await _channel.invokeMethod("getProfile");
  }
}
