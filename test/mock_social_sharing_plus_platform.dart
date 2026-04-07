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

  Future<void> Function(
    String message, {
    bool isOpenBrowser,
    VoidCallback? onAppNotInstalled,
  })? onShareInstagramDirect;

  Future<void> Function(
    String filePath, {
    String? content,
    bool isOpenBrowser,
    VoidCallback? onAppNotInstalled,
  })? onShareInstagramFeed;

  Future<void> Function(
    List<String> filePaths, {
    String? content,
    bool isOpenBrowser,
    VoidCallback? onAppNotInstalled,
  })? onShareInstagramFeedMultiple;

  Future<void> Function(
    String videoPath, {
    bool isOpenBrowser,
    VoidCallback? onAppNotInstalled,
  })? onShareInstagramReels;

  Future<void> Function({
    required String appId,
    String? stickerImage,
    String? backgroundImage,
    String? backgroundVideo,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? attributionURL,
    bool isOpenBrowser,
    VoidCallback? onAppNotInstalled,
  })? onShareInstagramStory;

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

  @override
  Future<void> shareInstagramDirect(
    String message, {
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareInstagramDirect?.call(
          message,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }

  @override
  Future<void> shareInstagramFeed(
    String filePath, {
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareInstagramFeed?.call(
          filePath,
          content: content,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }

  @override
  Future<void> shareInstagramFeedMultiple(
    List<String> filePaths, {
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareInstagramFeedMultiple?.call(
          filePaths,
          content: content,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }

  @override
  Future<void> shareInstagramReels(
    String videoPath, {
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) {
    return onShareInstagramReels?.call(
          videoPath,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
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
  }) {
    return onShareInstagramStory?.call(
          appId: appId,
          stickerImage: stickerImage,
          backgroundImage: backgroundImage,
          backgroundVideo: backgroundVideo,
          backgroundTopColor: backgroundTopColor,
          backgroundBottomColor: backgroundBottomColor,
          attributionURL: attributionURL,
          isOpenBrowser: isOpenBrowser,
          onAppNotInstalled: onAppNotInstalled,
        ) ??
        Future<void>.value();
  }
}
