package io.tuantvu.flutterlinkedinlogin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.linkedin.platform.LISessionManager
import com.linkedin.platform.errors.LIAuthError
import com.linkedin.platform.listeners.AuthListener
import com.linkedin.platform.utils.Scope
import org.json.JSONObject

/**
 * This class is needed because onActivityResult must call LISessionManager's onActivityResult. Forcing
 * the user of this plugin to override onActivityResult in their MainActivity is an option, but
 * this is a more elegant solution. This activity is invisible, but prevents the MainActivity shown from
 * accepting any inputs while open
 */
class LinkedInActivity : Activity() {

  /**
   * Simply calls LISessionManager's init
   */
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    //Grab the global reference of the result callback from the plugin
    val result = FlutterLinkedinLoginPlugin.result
    val activity = this
    LISessionManager.getInstance(this.applicationContext).init(
        activity,
        buildScope(),
        object : AuthListener {
          override fun onAuthSuccess() {
            Log.i(FlutterLinkedinLoginPlugin.TAG, "onAuthSuccess")
            result.success("Logged in")
            activity.finish()
          }

          override fun onAuthError(error: LIAuthError) {
            Log.e(FlutterLinkedinLoginPlugin.TAG, "onAuthError: " + error.toString())
            //LIAuthError doesn't expose individual fields so reading its toString as JSON
            val jsonObject = JSONObject(error.toString())
            val errorCode = if (jsonObject.has("errorCode")) jsonObject.getString("errorCode") else null
            val errorMessage = if (jsonObject.has("errorMessage"))  jsonObject.getString("errorMessage") else null
            result.error(errorCode, errorMessage, null)
            activity.finish()
          }
        },
        true
    )
  }

  private fun buildScope(): Scope {
    return Scope.build(Scope.R_BASICPROFILE, Scope.R_EMAILADDRESS)
  }

  /**
   * Calls LISessionManager's onActivityResult
   */
  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    Log.d(FlutterLinkedinLoginPlugin.TAG, "LinkedInActivity.onActivityResult")
    LISessionManager.getInstance(applicationContext).onActivityResult(this,
        requestCode, resultCode, data)
    super.onActivityResult(requestCode, resultCode, data)
  }
}
