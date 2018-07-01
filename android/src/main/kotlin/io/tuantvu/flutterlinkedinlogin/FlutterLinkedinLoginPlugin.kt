package io.tuantvu.flutterlinkedinlogin

import android.app.Activity
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

/**
 * FlutterLinkedInLoginPlugin delegates the call to LinkedIn to LinkedInActivity due to the
 * need to override onActivityResult.
 * Method channel name: "flutter_linkedin_login".
 * Call methods: "logIntoLinkedIn" and "getLinkedInProfile".
 */
class FlutterLinkedinLoginPlugin(private val mainActivity: Activity) : MethodCallHandler {

  companion object {
    //Result could not be passed around as a Parcelable or Serializable, so using a global static reference
    @JvmStatic
    lateinit var result: Result

    @JvmStatic
    val TAG = "FlutterLinkedInPlugin" //Tag for logging

    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login")
      channel.setMethodCallHandler(FlutterLinkedinLoginPlugin(registrar.activity()))
    }
  }

  /**
   * For logIntoLinkedIn, delegates work to LinkedInActivity
   */
  override fun onMethodCall(call: MethodCall, result: Result): Unit {
    if (call.method == "logIntoLinkedIn") run {
      Log.d(TAG, "logIntoLinkedIn: starting LinkedInActivity")
      val linkedInActivityIntent = Intent(mainActivity, LinkedInActivity::class.java)
      Companion.result = result
      mainActivity.startActivity(linkedInActivityIntent)
    } else if(call.method == "getProfile") {
      Log.d(TAG, "getProfile: starting GetLinkedInProfileActivity")
      val getLinkedInProfileActivity = Intent(mainActivity, GetLinkedInProfileActivity::class.java)
      Companion.result = result
      mainActivity.startActivity(getLinkedInProfileActivity)
    } else {
      result.notImplemented()
    }
  }
}
