package io.tuantvu.flutterlinkedinloginexample

import android.content.Intent
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.tuantvu.flutterlinkedinlogin.FlutterLinkedinLoginPlugin

class MainActivity() : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    FlutterLinkedinLoginPlugin.onActivityResult(this, requestCode, resultCode, data)
    super.onActivityResult(requestCode, resultCode, data)
  }
}
