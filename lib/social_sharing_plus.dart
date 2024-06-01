library social_sharing_plus;

import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:social_sharing_plus/src/social_platform.dart';

import 'src/social_sharing_plus_platform_interface.dart';

export 'src/social_platform.dart';

class SocialSharingPlus {
  /// A singleton instance of [SocialSharingPlus].
  static final SocialSharingPlus _instance = SocialSharingPlus._internal();

  /// Private constructor for [SocialSharingPlus] to implement singleton pattern.
  SocialSharingPlus._internal();

  /// Factory constructor to return the singleton instance.
  factory SocialSharingPlus() => _instance;

  /// Shares content to the specified social media platform.
  ///
  /// * [socialPlatform]: The platform to share the content on.
  /// * [content]: The content to be shared.
  /// * [image]: The image to be shared. (Android only)
  /// * [isOpenBrowser]: Whether to open a browser if the app is not installed.
  /// * [onAppNotInstalled]: Callback function to be called if the app is not installed. If `isOpenBrowser` is true, this method is ignored.
  static Future<void> shareToSocialMedia(
    SocialPlatform socialPlatform,
    String content, {
    String? image,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareToSocialMedia(
        socialPlatform,
        content,
        image: image,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );
}
