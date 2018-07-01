import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterLinkedinLogin {
  static const MethodChannel _channel =
      const MethodChannel('io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login');

  static Future<String> get login async {
    return await _channel.invokeMethod('logIntoLinkedIn');
  }

  static Future<LinkedInProfile> get profile async {
    String response = await _channel.invokeMethod("getProfile");
    Map profile = json.decode(response);
    return new LinkedInProfile.fromJson(profile);
  }
}

class LinkedInProfile {
  String firstName;
  String lastName;
  String headline;
  String id;
  String pictureUrl;
  String summary;
  String title;
  String industry;

  LinkedInProfile.fromJson(Map json) {
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.headline = json['headline'];
    this.id = json['id'];
    this.pictureUrl = json['pictureUrl'];
    this.summary = json['summary'];
    this.industry = json['industry'];
  }

  @override
  String toString() {
    return "id: $id, firstName: $firstName, lastName: $lastName, headline: $headline,"
        " pictureUrl: $pictureUrl, industry: $industry, summary: $summary";
  }


}