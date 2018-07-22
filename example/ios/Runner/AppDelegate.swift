import UIKit
import Flutter
import os

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    NSLog("%s", "hello world")
    os_log("this is a log message")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    open: URL,
    sourceApplication: String?,
    annotation: Any) -> Bool {
    os_log("this is a log callback")
    NSLog("%s", "callback");
    return FlutterLinkedinLoginPlugin.application(application,
                                           open: open,
                                           sourceApplication: sourceApplication,
                                           annotation: annotation)
    }
    
    override func application(_ app: UIApplication, open: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (FlutterLinkedinLoginPlugin.shouldHandle(open)) {
            return FlutterLinkedinLoginPlugin.application(app,
                                                          open: open,
                                                          sourceApplication: nil,
                                                          annotation: nil)
        }
        return true
    }
    
}
