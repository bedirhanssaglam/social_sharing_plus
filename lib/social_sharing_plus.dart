import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:social_sharing_plus/src/social_platform.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_platform_interface.dart';

export 'src/social_platform.dart';

/// A singleton class for sharing content to social media platforms.
///
/// This class provides a singleton instance to share content to various social media platforms.
/// It follows the singleton pattern, ensuring that only one instance of the class is created.
class SocialSharingPlus {
  /// Factory constructor to return the singleton instance.
  factory SocialSharingPlus() => _instance;

  /// Private constructor for [SocialSharingPlus] to implement singleton pattern.
  SocialSharingPlus._internal();

  /// A singleton instance of [SocialSharingPlus].
  static final SocialSharingPlus _instance = SocialSharingPlus._internal();

  /// Shares content to the specified social media platform.
  ///
  /// * [socialPlatform]: The platform to share the content on.
  /// * [content]: The content to be shared.
  /// * [image]: The image to be shared. (deprecated, use [media] instead)
  /// * [media]: The video or image to be shared.
  /// * [isOpenBrowser]: Whether to open a browser if the app is not installed.
  /// * [onAppNotInstalled]: Callback function to be called if the app is not installed. If `isOpenBrowser` is true, this method is ignored.
  static Future<void> shareToSocialMedia(
    SocialPlatform socialPlatform,
    String content, {
    @Deprecated('Please use the "media" parameter instead.') String? image,
    String? media,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareToSocialMedia(
        socialPlatform,
        content,
        image: image,
        media: media,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );
}
