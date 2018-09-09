import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

///Helper class to call platform channels for LinkedIn APIs
class FlutterLinkedinLogin {
  static const MethodChannel _channel =
      const MethodChannel('io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login');

  static Future<String> loginBasic() async {
    return await _channel.invokeMethod('loginBasic');
  }

//  static Future<String> loginFull() async {
//    return await _channel.invokeMethod('loginFull');
//  }

  static Future<LinkedInProfile> loginBasicWithProfile() async {
    await loginBasic();
    return await getProfile();
  }

//  static Future<LinkedInProfile> loginFullWithProfile() async {
//    await loginFull();
//    return await getProfile();
//  }

  static Future<String> logout() async {
    return await _channel.invokeMethod("logout");
  }

  static Future<LinkedInProfile> getProfile() async {
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
  String industry;
  String emailAddress;
  String formattedName;
  LinkedInLocation location;

  LinkedInProfile.fromJson(Map json) {
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.headline = json['headline'];
    this.id = json['id'];
    this.pictureUrl = json['pictureUrl'];
    this.summary = json['summary'];
    this.industry = json['industry'];
    this.emailAddress = json['emailAddress'];
    this.formattedName = json['formattedName'];
    this.location = LinkedInLocation.fromJson(json['location']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'headline': headline,
      'id': id,
      'pictureUrl': pictureUrl,
      'summary': summary,
      'industry': industry,
      'emailAddress': emailAddress,
      'formattedName': formattedName,
      'location': location.toJson(),
    };
  }

  @override
  String toString() {
    return 'LinkedInProfile{firstName: $firstName, lastName: $lastName, headline: $headline, id: $id, pictureUrl: $pictureUrl, summary: $summary, industry: $industry, emailAddress: $emailAddress, formattedName: $formattedName, location: $location}';
  }


}

class LinkedInLocation {
  String countryCode;
  String name;

  LinkedInLocation.fromJson(Map json) {
    if (json != null) {
      this.countryCode = json['country'] != null ? json['country']['code'] : null;
      this.name = json['name'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'LinkedInLocation{countryCode: $countryCode, name: $name}';
  }


}
