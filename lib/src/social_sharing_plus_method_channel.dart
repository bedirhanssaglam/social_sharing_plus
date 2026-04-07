import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:social_sharing_plus/src/social_platform.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_platform_interface.dart';

/// An implementation of [SocialSharingPlusPlatform] that uses method channels.
class MethodChannelSocialSharingPlus extends SocialSharingPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social_sharing_plus');

  Future<void> _invokeSharingMethod(
    String method,
    Map<String, dynamic> arguments, {
    required String failureLabel,
    required bool isOpenBrowser,
    VoidCallback? onAppNotInstalled,
  }) async {
    try {
      await methodChannel.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      if (e.code == 'APP_NOT_INSTALLED' && !isOpenBrowser) {
        onAppNotInstalled?.call();
        return;
      }
      throw Exception('Failed to $failureLabel: ${e.message}');
    }
  }

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
    await _invokeSharingMethod(
      platform.methodName,
      {
        'content': content,
        'media': media,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share to $platform',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }

  /// Shares content to the specified social media platform with multiple media files.
  ///
  /// This method allows sharing multiple media files (images or videos) to the selected social media platform.
  /// This feature is primarily intended for [Android]. On [iOS], Instagram is
  /// forwarded to its native handler while other platforms fall back to the
  /// first media file.
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
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        platform != SocialPlatform.instagram) {
      await shareToSocialMedia(
        platform,
        content ?? '',
        media: media.isNotEmpty ? media.first : null,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );
      return;
    }

    await _invokeSharingMethod(
      platform.methodName,
      {
        'content': content,
        'media': media,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share to $platform',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }

  @override
  Future<void> shareInstagramDirect(
    String message, {
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) async {
    await _invokeSharingMethod(
      'instagramDirect',
      {
        'message': message,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share to Instagram Direct',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }

  @override
  Future<void> shareInstagramFeed(
    String filePath, {
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) async {
    await _invokeSharingMethod(
      'instagramFeed',
      {
        'filePath': filePath,
        'content': content,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share to Instagram Feed',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }

  @override
  Future<void> shareInstagramFeedMultiple(
    List<String> filePaths, {
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) async {
    await _invokeSharingMethod(
      'instagramFeedMultiple',
      {
        'filePaths': filePaths,
        'content': content,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share multiple files to Instagram Feed',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }

  @override
  Future<void> shareInstagramReels(
    String videoPath, {
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) async {
    await _invokeSharingMethod(
      'instagramReels',
      {
        'videoPath': videoPath,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share to Instagram Reels',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }

  @override
  Future<void> shareInstagramStory({
    required String appId,
    String? stickerImage,
    String? backgroundImage,
    String? backgroundVideo,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? attributionURL,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) async {
    await _invokeSharingMethod(
      'instagramStory',
      {
        'appId': appId,
        'stickerImage': stickerImage,
        'backgroundImage': backgroundImage,
        'backgroundVideo': backgroundVideo,
        'backgroundTopColor': backgroundTopColor,
        'backgroundBottomColor': backgroundBottomColor,
        'attributionURL': attributionURL,
        'isOpenBrowser': isOpenBrowser,
      },
      failureLabel: 'share to Instagram Stories',
      isOpenBrowser: isOpenBrowser,
      onAppNotInstalled: onAppNotInstalled,
    );
  }
}
