package io.tuantvu.flutterlinkedinlogin

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.linkedin.platform.LISessionManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/**
 * FlutterLinkedInLoginPlugin delegates the call to LinkedIn to LinkedInActivity due to the
 * need to override onActivityResult.
 * Method channel name: "flutter_linkedin_login".
 * Call methods: "logIntoLinkedIn", "getLinkedInProfile", "clearSession".
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
      val channel = MethodChannel(registrar.messenger(),
          "io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login")
      channel.setMethodCallHandler(FlutterLinkedinLoginPlugin(registrar.activity()))
    }
  }

  /**
   * Determines which functionality to call
   */
  override fun onMethodCall(call: MethodCall, result: Result): Unit {
    when {
      call.method == "logIntoLinkedIn" -> logIntoLinkedIn(result)
      call.method == "getProfile" -> getProfile(result)
      call.method =="clearSession" -> clearSession(result)
      else -> result.notImplemented()
    }
  }

  /**
   * Checks to see if the access token is still valid. If so, inits the session with
   * the token. If not, then starts LinkedInActivity to log in
   */
  private fun logIntoLinkedIn(result: Result) {
    val sessionManager = LISessionManager.getInstance(mainActivity.applicationContext)
    if (sessionManager.session.isValid) {
      Log.d(TAG, "logIntoLinkedIn: Access token still valid")
      sessionManager.init(sessionManager.session.accessToken)
      result.success("Access token still valid")
    } else {
      Log.d(TAG, "logIntoLinkedIn: starting LinkedInActivity")
      val linkedInActivityIntent = Intent(mainActivity, LinkedInActivity::class.java)
      Companion.result = result
      mainActivity.startActivity(linkedInActivityIntent)
    }
  }

  /**
   * Starts GetLinkedProfileActivity to get profile
   */
  private fun getProfile(result: Result) {
    Log.d(TAG, "getProfile: starting GetLinkedInProfileActivity")
    val getLinkedInProfileActivity = Intent(mainActivity, GetLinkedInProfileActivity::class.java)
    Companion.result = result
    mainActivity.startActivity(getLinkedInProfileActivity)
  }

  /**
   * Clears the access token from session
   */
  private fun clearSession(result: Result) {
    Log.d(TAG, "clearSession")
    val sessionManager = LISessionManager.getInstance(mainActivity.applicationContext)
    if (sessionManager.session.accessToken == null) {
      result.success("No session")
    } else {
      sessionManager.clearSession()
      result.success("Cleared session")
    }
  }
}
