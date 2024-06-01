package com.example.social_sharing_plus

import android.content.Context
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import android.net.Uri

/** SocialSharingPlusPlugin */
class SocialSharingPlusPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
  channel = MethodChannel(flutterPluginBinding.binaryMessenger, "social_sharing_plus")
  channel.setMethodCallHandler(this)
  context = flutterPluginBinding.applicationContext
}

override fun onMethodCall(call: MethodCall, result: Result) {
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
  val content = call.argument<String>("content")
  val imageUriString = call.argument<String>("image")
  val imageUri =
      imageUriString?.let {
        val file = File(it)
        FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file)
      }

  val intent = Intent(Intent.ACTION_SEND)
  intent.type = if (imageUri != null) "image/*" else "text/plain"
  intent.putExtra(Intent.EXTRA_TEXT, content)
  imageUri?.let { intent.putExtra(Intent.EXTRA_STREAM, it) }
  intent.setPackage(packageName)

  if (intent.resolveActivity(context.packageManager) != null) {
    if (call.hasArgument("isOpenBrowser") && call.argument<Boolean>("isOpenBrowser") ?: false
    ) { // Eğer isOpenBrowser argümanı var ve true ise tarayıcıda aç
      openInBrowser(packageName, content!!)
      result.error("APP_NOT_INSTALLED", "$packageName is not installed. Opening in browser.", null)
    } else {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      imageUri?.let { intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) }
      context.startActivity(intent)
      result.success(null)
    }
  } else {
    result.error("APP_NOT_INSTALLED", "$packageName is not installed", null)
  }
}

private fun openInBrowser(packageName: String, content: String) {
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
  webUrlString?.let {
    webIntent.data = Uri.parse(it)
    webIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
    context.startActivity(webIntent)
  }
}

override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  channel.setMethodCallHandler(null)
}

}
