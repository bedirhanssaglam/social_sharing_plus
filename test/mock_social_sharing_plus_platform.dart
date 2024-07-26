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

  Future<void> Function(
    SocialPlatform platform, {
    required List<String> media,
    required bool isOpenBrowser,
    String? content,
    VoidCallback? onAppNotInstalled,
  })? onShareToSocialMediaWithMultipleMedia;

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

  @override
  Future<void> shareToSocialMediaWithMultipleMedia(
    SocialPlatform platform, {
    required List<String> media,
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareToSocialMediaWithMultipleMedia?.call(
          platform,
          media: media,
          content: content,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }
}
