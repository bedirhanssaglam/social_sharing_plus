import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:social_sharing_plus/src/social_platform.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_platform_interface.dart';

/// An implementation of [SocialSharingPlusPlatform] that uses method channels.
class MethodChannelSocialSharingPlus extends SocialSharingPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social_sharing_plus');

  /// Shares content to the specified social media platform.
  ///
  /// * [platform]: The platform to share the content on.
  /// * [content]: The content to be shared.
  /// * [image]: The image to be shared. (deprecated, use [media] instead)
  /// * [media]: The video or image to be shared.
  /// * [isOpenBrowser]: Whether to open a browser if the app is not installed.
  /// * [onAppNotInstalled]: Callback function to be called if the app is not installed. If `isOpenBrowser` is true, this method is ignored.
  @override
  Future<void> shareToSocialMedia(
    SocialPlatform platform,
    String content, {
    required bool isOpenBrowser,
    @Deprecated('Please use the "media" parameter instead.') String? image,
    String? media,
    VoidCallback? onAppNotInstalled,
  }) async {
    try {
      await methodChannel.invokeMethod(platform.methodName, {
        'content': content,
        'media': media,
        'isOpenBrowser': isOpenBrowser,
      });
    } on PlatformException catch (e) {
      if (e.code == 'APP_NOT_INSTALLED' && !isOpenBrowser) {
        onAppNotInstalled?.call();
        return;
      }
      throw Exception('Failed to share to $platform: ${e.message}');
    }
  }

  /// Shares content to the specified social media platform with multiple media files.
  ///
  /// This method allows sharing multiple media files (images or videos) to the selected social media platform.
  /// Currently, this feature is only supported on [Android].
  ///
  /// * [socialPlatform]: The platform to share the content on.
  /// * [content]: The content to be shared.
  /// * [media]: A list of media file paths (images or videos) to be shared.
  /// * [isOpenBrowser]: Whether to open a browser if the app is not installed.
  /// * [onAppNotInstalled]: Callback function to be called if the app is not installed.
  @override
  Future<void> shareToSocialMediaWithMultipleMedia(
    SocialPlatform platform, {
    required List<String> media,
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) async {
    try {
      await methodChannel.invokeMethod(platform.methodName, {
        'content': content,
        'media': media,
        'isOpenBrowser': isOpenBrowser,
      });
    } on PlatformException catch (e) {
      if (e.code == 'APP_NOT_INSTALLED' && !isOpenBrowser) {
        onAppNotInstalled?.call();
        return;
      }
      throw Exception('Failed to share to $platform: ${e.message}');
    }
  }
}
