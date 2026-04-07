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
        media: media,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );

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
  static Future<void> shareToSocialMediaWithMultipleMedia(
    SocialPlatform platform, {
    required List<String> media,
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareToSocialMediaWithMultipleMedia(
        platform,
        media: media,
        content: content,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );

  /// Shares a text message to Instagram Direct.
  static Future<void> shareToInstagramDirect(
    String message, {
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareInstagramDirect(
        message,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );

  /// Shares an image or video to the Instagram feed.
  static Future<void> shareToInstagramFeed(
    String filePath, {
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareInstagramFeed(
        filePath,
        content: content,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );

  /// Shares multiple files to the Instagram feed.
  static Future<void> shareToInstagramFeedMultiple(
    List<String> filePaths, {
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareInstagramFeedMultiple(
        filePaths,
        content: content,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );

  /// Shares a video to Instagram Reels.
  static Future<void> shareToInstagramReels(
    String videoPath, {
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareInstagramReels(
        videoPath,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );

  /// Shares media to Instagram Stories.
  static Future<void> shareToInstagramStory({
    required String appId,
    String? stickerImage,
    String? backgroundImage,
    String? backgroundVideo,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? attributionURL,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  }) =>
      SocialSharingPlusPlatform.instance.shareInstagramStory(
        appId: appId,
        stickerImage: stickerImage,
        backgroundImage: backgroundImage,
        backgroundVideo: backgroundVideo,
        backgroundTopColor: backgroundTopColor,
        backgroundBottomColor: backgroundBottomColor,
        attributionURL: attributionURL,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: onAppNotInstalled,
      );
}
