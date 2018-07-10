import Flutter
import UIKit
import os.log

public class SwiftFlutterLinkedinLoginPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLinkedinLoginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    NSLog("%0.4f", CGFloat.pi)
    os_log("blah", type: .info)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    NSLog("%0.4f", CGFloat.pi)
    os_log("Currently at processing state: %@", log: .default, type: .error, call.method)
    result("iOS " + UIDevice.current.systemVersion)
  }
}
