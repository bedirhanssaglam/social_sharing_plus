import 'dart:ui' show VoidCallback;

import 'package:social_sharing_plus/social_sharing_plus.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_platform_interface.dart';

class MockSocialSharingPlusPlatform extends SocialSharingPlusPlatform {
  Future<void> Function(
    SocialPlatform platform,
    String content, {
    required bool isOpenBrowser,
    String? image,
    String? media,
    VoidCallback? onAppNotInstalled,
  })? onShareToSocialMedia;

  @override
  Future<void> shareToSocialMedia(
    SocialPlatform platform,
    String content, {
    required bool isOpenBrowser,
    String? image,
    String? media,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareToSocialMedia?.call(
          platform,
          content,
          image: image,
          media: media,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }
}
