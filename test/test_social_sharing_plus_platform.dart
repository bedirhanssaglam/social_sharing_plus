import 'dart:ui' show VoidCallback;

import 'package:social_sharing_plus/social_sharing_plus.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_platform_interface.dart';

class TestSocialSharingPlusPlatform extends SocialSharingPlusPlatform {
  Future<void> Function(
    SocialPlatform platform,
    String content, {
    required bool isOpenBrowser,
    String? image,
    VoidCallback? onAppNotInstalled,
  })? onShareToSocialMedia;

  @override
  Future<void> shareToSocialMedia(
    SocialPlatform platform,
    String content, {
    required bool isOpenBrowser,
    String? image,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareToSocialMedia?.call(
          platform,
          content,
          image: image,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }
}
