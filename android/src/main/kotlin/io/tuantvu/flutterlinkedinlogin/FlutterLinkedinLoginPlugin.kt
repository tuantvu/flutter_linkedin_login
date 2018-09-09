package io.tuantvu.flutterlinkedinlogin

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.linkedin.platform.APIHelper
import com.linkedin.platform.LISessionManager
import com.linkedin.platform.errors.LIApiError
import com.linkedin.platform.errors.LIAuthError
import com.linkedin.platform.listeners.ApiListener
import com.linkedin.platform.listeners.ApiResponse
import com.linkedin.platform.listeners.AuthListener
import com.linkedin.platform.utils.Scope
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONObject

/**
 * FlutterLinkedInLoginPlugin handles login, clearing session, and getting basic user
 * profile from LinkedIn. Clients must override onActivityResult in their MainActivity and
 * pass the parameters to FlutterLinkedInLoginPlugin.onActivityResult.
 * Method channel name: "io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login".
 * Call methods: "logIntoLinkedIn", "getLinkedInProfile", "clearSession".
 */
class FlutterLinkedinLoginPlugin(private val mainActivity: Activity) : MethodCallHandler {

  private val URL = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name," +
      "headline,industry,summary,picture-url,email-address,formatted-name,location,specialties,positions)?format=json"

  companion object {
    //Result could not be passed around as a Parcelable or Serializable, so using a global static reference
    @JvmStatic
    lateinit var result: Result

    @JvmStatic
    val TAG = "FlutterLinkedInPlugin" //Tag for logging

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(),
          "io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login")
      channel.setMethodCallHandler(FlutterLinkedinLoginPlugin(registrar.activity()))
    }

    /**
     * Calls LISessionManager's onActivityResult
     */
    @JvmStatic
    fun onActivityResult(activity: Activity, requestCode: Int, resultCode: Int, data: Intent?) {
      Log.d(FlutterLinkedinLoginPlugin.TAG, "GetLinkedInProfileActivity.onActivityResult")
      LISessionManager.getInstance(activity.applicationContext).onActivityResult(activity,
          requestCode, resultCode, data)
    }
  }

  /**
   * Determines which functionality to call
   */
  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
      call.method == "logIntoLinkedIn" -> logIntoLinkedIn(Scope.R_BASICPROFILE, result)
      call.method == "loginBasic" -> logIntoLinkedIn(Scope.R_BASICPROFILE, result)
      call.method == "loginFull" -> logIntoLinkedIn(Scope.R_FULLPROFILE, result)
      call.method == "loginBasicWithProfile" -> logIntoLinkedIn(Scope.R_BASICPROFILE, result)
      call.method == "loginFullWithProfile" -> logIntoLinkedIn(Scope.R_FULLPROFILE, result)
      call.method == "getProfile" -> getProfile(result)
      call.method =="clearSession" -> clearSession(result)
      call.method =="logout" -> clearSession(result)
      else -> result.notImplemented()
    }
  }

  /**
   * Checks to see if the access token is still valid. If so, inits the session with
   * the token. If not, then starts the login process
   */
  private fun logIntoLinkedIn(profile: Scope.LIPermission, result: Result) {
    Log.d(TAG, "logIntoLinkedIn: with profile: $profile")
    val sessionManager = LISessionManager.getInstance(mainActivity.applicationContext)
    if (sessionManager.session.isValid) {
      Log.d(TAG, "logIntoLinkedIn: Access token still valid")
      sessionManager.init(sessionManager.session.accessToken)
      result.success("Access token still valid")
    } else {
      Log.d(TAG, "logIntoLinkedIn: starting LinkedInActivity")
      LISessionManager.getInstance(mainActivity.applicationContext).init(
          mainActivity,
          Scope.build(profile, Scope.R_EMAILADDRESS),
          object : AuthListener {
            override fun onAuthSuccess() {
              Log.i(TAG, "onAuthSuccess")
              result.success("Logged in")
            }

            override fun onAuthError(error: LIAuthError) {
              Log.e(FlutterLinkedinLoginPlugin.TAG, "onAuthError: " + error.toString())
              //LIAuthError doesn't expose individual fields so reading its toString as JSON
              val jsonObject = JSONObject(error.toString())
              val errorCode = if (jsonObject.has("errorCode")) jsonObject.getString("errorCode") else null
              val errorMessage = if (jsonObject.has("errorMessage"))  jsonObject.getString("errorMessage") else null
              result.error(errorCode, errorMessage, null)
            }
          },
          true
      )
    }
  }

  /**
   * Gets basic profile
   */
  private fun getProfile(result: Result) {
    Log.d(TAG, "getProfile: starting GetLinkedInProfileActivity")
    if (LISessionManager.getInstance(mainActivity.applicationContext).session.isValid) {
      APIHelper.getInstance(mainActivity.applicationContext).getRequest(mainActivity, URL, object : ApiListener {
        override fun onApiSuccess(apiResponse: ApiResponse) {
          Log.d(TAG, "apiResponse: ${apiResponse.toString()}")
          val response = apiResponse.responseDataAsJson
          result.success(response.toString())
        }

        override fun onApiError(error: LIApiError) {
          Log.e(FlutterLinkedinLoginPlugin.TAG, error.toString())
          //Set access token is not set error type to http status code of unauthorized
          val httpStatus = if (error.errorType == LIApiError.ErrorType.accessTokenIsNotSet) 401 else error.httpStatusCode

          //If apiErrorResponse type, then get the message from the apiErrorResponse
          val message = error.apiErrorResponse?.message ?: error.message
          result.error(httpStatus.toString(), message, error.toString())
        }
      })
    } else {
      result.error("401", "access token is not set", null)
    }

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
