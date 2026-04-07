package com.example.social_sharing_plus

import android.content.ClipData
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import com.example.social_sharing_plus.utils.MediaType
import com.example.social_sharing_plus.utils.SharePaths
import com.example.social_sharing_plus.utils.SocialConstants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** SocialSharingPlusPlugin */
class SocialSharingPlusPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, SocialConstants.CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            SocialConstants.FACEBOOK ->
                    shareToSocialMedia(SocialConstants.FACEBOOK_PACKAGE_NAME, call, result)
            SocialConstants.TWITTER ->
                    shareToSocialMedia(SocialConstants.TWITTER_PACKAGE_NAME, call, result)
            SocialConstants.LINKEDIN ->
                    shareToSocialMedia(SocialConstants.LINKEDIN_PACKAGE_NAME, call, result)
            SocialConstants.WHATSAPP ->
                    shareToSocialMedia(SocialConstants.WHATSAPP_PACKAGE_NAME, call, result)
            SocialConstants.REDDIT ->
                    shareToSocialMedia(SocialConstants.REDDIT_PACKAGE_NAME, call, result)
            SocialConstants.TELEGRAM ->
                    shareToSocialMedia(SocialConstants.TELEGRAM_PACKAGE_NAME, call, result)
            SocialConstants.INSTAGRAM ->
                    shareToSocialMedia(SocialConstants.INSTAGRAM_PACKAGE_NAME, call, result)
            SocialConstants.INSTAGRAM_DIRECT -> shareInstagramDirect(call, result)
            SocialConstants.INSTAGRAM_FEED -> shareInstagramFeed(call, result)
            SocialConstants.INSTAGRAM_FEED_MULTIPLE -> shareInstagramFeedMultiple(call, result)
            SocialConstants.INSTAGRAM_REELS -> shareInstagramReels(call, result)
            SocialConstants.INSTAGRAM_STORY -> shareInstagramStory(call, result)
            else -> result.notImplemented()
        }
    }

    private fun shareToSocialMedia(packageName: String, call: MethodCall, result: Result) {
        val content: String? = call.argument<String>("content")
        val media: Any? = call.argument<Any>("media")
        val isOpenBrowser: Boolean = call.argument<Boolean>("isOpenBrowser") ?: false

        when (media) {
            is String -> {
                val mediaUri = getMediaUri(media, result) ?: return
                shareSingleMedia(packageName, content, mediaUri, media, result, isOpenBrowser)
            }
            is List<*> -> {
                val mediaPaths = media.filterIsInstance<String>().filter { it.isNotBlank() }

                if (mediaPaths.isEmpty()) {
                    shareSingleMedia(packageName, content, null, null, result, isOpenBrowser)
                    return
                }

                val mediaUris = ArrayList<Uri>(mediaPaths.size)
                for (mediaPath in mediaPaths) {
                    val mediaUri = getMediaUri(mediaPath, result) ?: return
                    mediaUris.add(mediaUri)
                }

                shareMultipleMedia(packageName, content, mediaUris, mediaPaths, result, isOpenBrowser)
            }
            else -> {
                shareSingleMedia(packageName, content, null, null, result, isOpenBrowser)
            }
        }
    }

    private fun shareSingleMedia(
            packageName: String,
            content: String?,
            mediaUri: Uri?,
            mediaPath: String?,
            result: Result,
            isOpenBrowser: Boolean
    ) {
        val intent: Intent =
                Intent(Intent.ACTION_SEND).apply {
                    type = mediaPath?.let { getMimeType(File(it)) } ?: SharePaths.TEXT_PLAIN.reference

                    putExtra(Intent.EXTRA_TEXT, content)
                    mediaUri?.let {
                        putExtra(Intent.EXTRA_STREAM, it)
                        clipData = ClipData.newRawUri("shared_media", it)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    setPackage(packageName)
                }

        if (intent.resolveActivity(context.packageManager) != null) {
            mediaUri?.let { grantReadPermission(packageName, listOf(it)) }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success(null)
        } else {
            if (isOpenBrowser) {
                openInBrowser(packageName, content ?: "", mediaUri)
                result.success(null)
            } else {
                result.error("APP_NOT_INSTALLED", "$packageName is not installed", null)
            }
        }
    }

    private fun shareMultipleMedia(
            packageName: String,
            content: String?,
            mediaUris: List<Uri>,
            mediaPaths: List<String>,
            result: Result,
            isOpenBrowser: Boolean,
            mimeTypeOverride: String? = null
    ) {
        val intent: Intent =
                Intent(Intent.ACTION_SEND_MULTIPLE).apply {
                    type = mimeTypeOverride ?: getMultipleMimeType(mediaPaths)
                    putExtra(Intent.EXTRA_TEXT, content)

                    if (mediaUris.isNotEmpty()) {
                        putParcelableArrayListExtra(Intent.EXTRA_STREAM, ArrayList(mediaUris))
                        val clip = ClipData.newUri(
                                context.contentResolver,
                                "shared_media",
                                mediaUris.first()
                        )
                        mediaUris.drop(1).forEach { clip.addItem(ClipData.Item(it)) }
                        clipData = clip
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    setPackage(packageName)
                }

        if (intent.resolveActivity(context.packageManager) != null) {
            grantReadPermission(packageName, mediaUris)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            result.success(null)
        } else {
            if (isOpenBrowser) {
                openInBrowser(packageName, content ?: "", mediaUris.firstOrNull())
                result.success(null)
            } else {
                result.error("APP_NOT_INSTALLED", "$packageName is not installed", null)
            }
        }
    }

    private fun shareInstagramDirect(call: MethodCall, result: Result) {
        val message: String? = call.argument<String>("message")
        val isOpenBrowser: Boolean = call.argument<Boolean>("isOpenBrowser") ?: false

        shareSingleMedia(
                SocialConstants.INSTAGRAM_PACKAGE_NAME,
                message,
                null,
                null,
                result,
                isOpenBrowser
        )
    }

    private fun shareInstagramFeed(call: MethodCall, result: Result) {
        val filePath = extractInstagramFilePath(call)
        val content: String? = call.argument<String>("content")
        val isOpenBrowser: Boolean = call.argument<Boolean>("isOpenBrowser") ?: false

        if (filePath.isNullOrBlank()) {
            result.error("ARGUMENT_ERROR", "Instagram feed sharing requires a valid filePath", null)
            return
        }

        val mediaUri = getMediaUri(filePath, result) ?: return
        shareSingleMedia(
                SocialConstants.INSTAGRAM_PACKAGE_NAME,
                content,
                mediaUri,
                filePath,
                result,
                isOpenBrowser
        )
    }

    private fun shareInstagramFeedMultiple(call: MethodCall, result: Result) {
        val filePaths = extractInstagramFilePaths(call)
        val content: String? = call.argument<String>("content")
        val isOpenBrowser: Boolean = call.argument<Boolean>("isOpenBrowser") ?: false

        if (filePaths.isEmpty()) {
            result.error(
                    "ARGUMENT_ERROR",
                    "Instagram feed multiple sharing requires at least one valid filePath",
                    null
            )
            return
        }

        val mediaUris = ArrayList<Uri>(filePaths.size)
        for (filePath in filePaths) {
            val mediaUri = getMediaUri(filePath, result) ?: return
            mediaUris.add(mediaUri)
        }

        shareMultipleMedia(
                SocialConstants.INSTAGRAM_PACKAGE_NAME,
                content,
                mediaUris,
                filePaths,
                result,
                isOpenBrowser
        )
    }

    private fun shareInstagramReels(call: MethodCall, result: Result) {
        val videoPath = (call.argument<String>("videoPath")) ?: extractInstagramFilePath(call)
        val isOpenBrowser: Boolean = call.argument<Boolean>("isOpenBrowser") ?: false

        if (videoPath.isNullOrBlank()) {
            result.error("ARGUMENT_ERROR", "Instagram Reels sharing requires a valid videoPath", null)
            return
        }

        if (!getMimeType(File(videoPath)).startsWith("video/")) {
            result.error("VIDEO_ERROR", "Instagram Reels sharing requires a video file", null)
            return
        }

        val mediaUri = getMediaUri(videoPath, result) ?: return
        shareSingleMedia(
                SocialConstants.INSTAGRAM_PACKAGE_NAME,
                null,
                mediaUri,
                videoPath,
                result,
                isOpenBrowser
        )
    }

    private fun shareInstagramStory(call: MethodCall, result: Result) {
        val appId: String = call.argument<String>("appId").orEmpty()
        val isOpenBrowser: Boolean = call.argument<Boolean>("isOpenBrowser") ?: false

        if (appId.isBlank()) {
            result.error("ARGUMENT_ERROR", "Instagram Stories sharing requires an appId", null)
            return
        }

        val intent =
                Intent(SocialConstants.INSTAGRAM_STORY_ACTION).apply {
                    setPackage(SocialConstants.INSTAGRAM_PACKAGE_NAME)
                    putExtra("source_application", appId)
                }

        val backgroundVideoPath = call.argument<String>("backgroundVideo")
        val backgroundImagePath = call.argument<String>("backgroundImage")
        val stickerImagePath = call.argument<String>("stickerImage")

        val urisToGrant = mutableListOf<Uri>()

        if (!backgroundVideoPath.isNullOrBlank()) {
            val mediaUri = getMediaUri(backgroundVideoPath, result) ?: return
            intent.setDataAndType(mediaUri, "video/*")
            urisToGrant.add(mediaUri)
        } else if (!backgroundImagePath.isNullOrBlank()) {
            val mediaUri = getMediaUri(backgroundImagePath, result) ?: return
            intent.setDataAndType(mediaUri, getMimeType(File(backgroundImagePath)))
            urisToGrant.add(mediaUri)
        }

        if (!stickerImagePath.isNullOrBlank()) {
            val stickerUri = getMediaUri(stickerImagePath, result) ?: return
            intent.putExtra("interactive_asset_uri", stickerUri)
            urisToGrant.add(stickerUri)
        }

        call.argument<String>("backgroundTopColor")?.takeIf { it.isNotBlank() }?.let {
            intent.putExtra("top_background_color", it)
        }
        call.argument<String>("backgroundBottomColor")?.takeIf { it.isNotBlank() }?.let {
            intent.putExtra("bottom_background_color", it)
        }
        call.argument<String>("attributionURL")?.takeIf { it.isNotBlank() }?.let {
            intent.putExtra("content_url", it)
        }

        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        if (intent.resolveActivity(context.packageManager) != null) {
            grantReadPermission(SocialConstants.INSTAGRAM_PACKAGE_NAME, urisToGrant)
            context.startActivity(intent)
            result.success(null)
        } else if (isOpenBrowser) {
            openInBrowser(SocialConstants.INSTAGRAM_PACKAGE_NAME, "", urisToGrant.firstOrNull())
            result.success(null)
        } else {
            result.error(
                    "APP_NOT_INSTALLED",
                    "${SocialConstants.INSTAGRAM_PACKAGE_NAME} is not installed",
                    null
            )
        }
    }

    private fun openInBrowser(packageName: String, content: String, mediaUri: Uri?) {
        val webIntent = Intent(Intent.ACTION_VIEW)
        val webUrlString: String? =
                when (packageName) {
                    SocialConstants.FACEBOOK_PACKAGE_NAME ->
                            "${SocialConstants.FACEBOOK_WEB_URL}$content"
                    SocialConstants.TWITTER_PACKAGE_NAME ->
                            "${SocialConstants.TWITTER_WEB_URL}$content"
                    SocialConstants.LINKEDIN_PACKAGE_NAME ->
                            "${SocialConstants.LINKEDIN_WEB_URL}$content"
                    SocialConstants.WHATSAPP_PACKAGE_NAME ->
                            "${SocialConstants.WHATSAPP_WEB_URL}$content"
                    SocialConstants.REDDIT_PACKAGE_NAME ->
                            "${SocialConstants.REDDIT_WEB_URL}$content"
                    SocialConstants.TELEGRAM_PACKAGE_NAME ->
                            "${SocialConstants.TELEGRAM_WEB_URL}$content"
                    SocialConstants.INSTAGRAM_PACKAGE_NAME ->
                            SocialConstants.INSTAGRAM_WEB_URL
                    else -> null
                }

        val mediaParam: String? =
                mediaUri?.let {
                    val mimeType = context.contentResolver.getType(it).orEmpty()
                    if (mimeType.startsWith("video/")) {
                        "${SharePaths.VIDEO_URL.reference}${Uri.encode(mediaUri.toString())}"
                    } else {
                        "${SharePaths.IMAGE_URL.reference}${Uri.encode(mediaUri.toString())}"
                    }
                }

        val finalUrlString: String? =
                webUrlString?.let { url ->
                    if (packageName == SocialConstants.INSTAGRAM_PACKAGE_NAME || mediaParam == null) {
                        url
                    } else {
                        "$url&$mediaParam"
                    }
                }

        finalUrlString?.let {
            webIntent.data = Uri.parse(it)
            webIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(webIntent)
        }
    }

    private fun getMediaUri(mediaPath: String, result: Result): Uri? {
        val file = File(mediaPath)
        if (!file.exists()) {
            result.error("FILE_NOT_FOUND", "Media file not found: $mediaPath", null)
            return null
        }

        return FileProvider.getUriForFile(
                context,
                "${context.packageName}.fileprovider",
                file
        )
    }

    private fun extractInstagramFilePath(call: MethodCall): String? {
        call.argument<String>("filePath")?.takeIf { it.isNotBlank() }?.let { return it }
        call.argument<String>("media")?.takeIf { it.isNotBlank() }?.let { return it }
        return extractInstagramFilePaths(call).firstOrNull()
    }

    private fun extractInstagramFilePaths(call: MethodCall): List<String> {
        val filePaths = call.argument<List<String>>("filePaths")
        if (!filePaths.isNullOrEmpty()) {
            return filePaths.filter { it.isNotBlank() }
        }

        val mediaPaths = call.argument<List<String>>("media")
        if (!mediaPaths.isNullOrEmpty()) {
            return mediaPaths.filter { it.isNotBlank() }
        }

        val singlePath = call.argument<String>("filePath") ?: call.argument<String>("media")
        return singlePath?.takeIf { it.isNotBlank() }?.let(::listOf) ?: emptyList()
    }

    private fun grantReadPermission(packageName: String, mediaUris: List<Uri>) {
        for (mediaUri in mediaUris) {
            context.grantUriPermission(
                    packageName,
                    mediaUri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        }
    }

    private fun getMimeType(file: File): String {
        return when (file.extension.lowercase()) {
            "jpg", "jpeg" -> "image/jpeg"
            "png" -> "image/png"
            "gif" -> "image/gif"
            "webp" -> "image/webp"
            SharePaths.MP4.reference -> "video/mp4"
            "mov" -> "video/quicktime"
            "avi" -> "video/x-msvideo"
            "m4v" -> "video/x-m4v"
            "mkv" -> "video/x-matroska"
            else -> MediaType.IMAGE.reference
        }
    }

    private fun getMultipleMimeType(mediaPaths: List<String>): String {
        val mimeTypes = mediaPaths.map { getMimeType(File(it)) }

        return when {
            mimeTypes.all { it.startsWith("image/") } -> MediaType.IMAGE.reference
            mimeTypes.all { it.startsWith("video/") } -> MediaType.VIDEO.reference
            else -> "*/*"
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
