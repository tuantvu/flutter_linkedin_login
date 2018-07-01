package io.tuantvu.flutterlinkedinlogin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.linkedin.platform.APIHelper
import com.linkedin.platform.LISessionManager
import com.linkedin.platform.errors.LIApiError
import com.linkedin.platform.listeners.ApiListener
import com.linkedin.platform.listeners.ApiResponse

class GetLinkedInProfileActivity : Activity() {

  val url = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name," +
      "headline,industry,summary,picture-url)?format=json"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    val result = FlutterLinkedinLoginPlugin.result
    val activity = this

    APIHelper.getInstance(applicationContext).getRequest(activity, url, object : ApiListener {
      override fun onApiSuccess(apiResponse: ApiResponse) {
        Log.d(FlutterLinkedinLoginPlugin.TAG, apiResponse.toString())
        val response = apiResponse.responseDataAsJson
        result.success(response.toString())
        activity.finish()
      }

      override fun onApiError(error: LIApiError) {
        Log.e(FlutterLinkedinLoginPlugin.TAG, error.toString())
        result.error(error.errorType.name, error.message, null)
        activity.finish()
      }
    })
  }

  /**
   * Calls LISessionManager's onActivityResult
   */
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    Log.d(FlutterLinkedinLoginPlugin.TAG, "GetLinkedInProfileActivity.onActivityResult")
    LISessionManager.getInstance(applicationContext).onActivityResult(this,
        requestCode, resultCode, data)
    super.onActivityResult(requestCode, resultCode, data)
  }
}
