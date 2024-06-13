package com.example.social_sharing_plus

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** SocialSharingPlusPlugin */
class SocialSharingPlusPlugin : FlutterPlugin, MethodCallHandler {

  // MethodChannel to handle communication between Flutter and native Android
  private lateinit var channel: MethodChannel

  // Context reference to store the application context
  private lateinit var context: Context

  // Called when the plugin is attached to the Flutter engine
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // Initialize MethodChannel with the binaryMessenger and set MethodCallHandler
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "social_sharing_plus")
    channel.setMethodCallHandler(this)
    // Retrieve the application context
    context = flutterPluginBinding.applicationContext
  }

  // Handles method calls from Flutter
  override fun onMethodCall(call: MethodCall, result: Result) {
    // Process method calls based on method name
    when (call.method) {
      "shareToFacebook" -> shareToSocialMedia("com.facebook.katana", call, result)
      "shareToTwitter" -> shareToSocialMedia("com.twitter.android", call, result)
      "shareToLinkedIn" -> shareToSocialMedia("com.linkedin.android", call, result)
      "shareToWhatsApp" -> shareToSocialMedia("com.whatsapp", call, result)
      "shareToReddit" -> shareToSocialMedia("com.reddit.frontpage", call, result)
      "shareToTelegram" -> shareToSocialMedia("org.telegram.messenger", call, result)
      else -> result.notImplemented()
    }
  }

private fun shareToSocialMedia(packageName: String, call: MethodCall, result: Result) {
  // Retrieve arguments from Flutter method call
  val content = call.argument<String>("content")
  val imageUriString = call.argument<String>("image")
  // Convert image file path to URI using FileProvider
  val imageUri =
      imageUriString?.let {
        val file = File(it)
        FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file)
      }

  // INTENT SETUP FOR SHARING
  val intent = Intent(Intent.ACTION_SEND)
  intent.type = if (imageUri != null) "image/*" else "text/plain"
  intent.putExtra(Intent.EXTRA_TEXT, content)
  imageUri?.let { intent.putExtra(Intent.EXTRA_STREAM, it) }
  intent.setPackage(packageName)

  // If the app can handle the intent, start the sharing process
  if (intent.resolveActivity(context.packageManager) != null) {
    if (call.hasArgument("isOpenBrowser") && call.argument<Boolean>("isOpenBrowser") ?: false) {
      // If isOpenBrowser argument is true, open in browser instead
      openInBrowser(packageName, content!!)
      result.success(null) // Return success as we opened in browser
    } else {
      // Start the intent for direct sharing
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      imageUri?.let { intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) }
      context.startActivity(intent)
      result.success(null)
    }
  } else {
    if (call.hasArgument("isOpenBrowser") && call.argument<Boolean>("isOpenBrowser") ?: false) {
      // If isOpenBrowser is true but the app is not installed, open in browser
      openInBrowser(packageName, content ?: "")
      result.success(null) // Return success as we opened in browser
    } else {
      // If the app is not installed, return an error
      result.error("APP_NOT_INSTALLED", "$packageName is not installed", null)
    }
  }
}


  // Opens the sharing content in a browser
  private fun openInBrowser(packageName: String, content: String) {
    // Create an intent to open the web-based sharing URL
    val webIntent = Intent(Intent.ACTION_VIEW)
    val webUrlString =
        when (packageName) {
          "com.facebook.katana" -> "https://www.facebook.com/sharer/sharer.php?u=$content"
          "com.twitter.android" -> "https://twitter.com/intent/tweet?text=$content"
          "com.linkedin.android" -> "https://www.linkedin.com/sharing/share-offsite/?url=$content"
          "com.whatsapp" -> "https://api.whatsapp.com/send?text=$content"
          "com.reddit.frontpage" -> "https://www.reddit.com/submit?title=$content"
          "org.telegram.messenger" -> "https://t.me/share/url?url=$content"
          else -> null
        }
    // If a web URL is available, open in browser
    webUrlString?.let {
      webIntent.data = Uri.parse(it)
      webIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      context.startActivity(webIntent)
    }
  }

  // Called when the plugin is detached from the Flutter engine
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    // Remove the MethodChannel handler
    channel.setMethodCallHandler(null)
  }
}
