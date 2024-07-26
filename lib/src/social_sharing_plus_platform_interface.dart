import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:social_sharing_plus/src/social_platform.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_method_channel.dart';

abstract class SocialSharingPlusPlatform extends PlatformInterface {
  /// Constructs a SocialSharingPlusPlatform.
  SocialSharingPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialSharingPlusPlatform _instance = MethodChannelSocialSharingPlus();

  /// The default instance of [SocialSharingPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelSocialSharingPlus].
  static SocialSharingPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocialSharingPlusPlatform] when
  /// they register themselves.
  static set instance(SocialSharingPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Shares content to the specified social media platform.
  ///
  /// * [platform]: The platform to share the content on.
  /// * [content]: The content to be shared.
  /// * [image]: The image to be shared. (deprecated, use [media] instead)
  /// * [media]: The video or image to be shared.
  /// * [isOpenBrowser]: Whether to open a browser if the app is not installed.
  /// * [onAppNotInstalled]: Callback function to be called if the app is not installed. If `isOpenBrowser` is true, this method is ignored.
  Future<void> shareToSocialMedia(
    SocialPlatform platform,
    String content, {
    required bool isOpenBrowser,
    @Deprecated('Please use the "media" parameter instead.') String? image,
    String? media,
    VoidCallback? onAppNotInstalled,
  });

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
  Future<void> shareToSocialMediaWithMultipleMedia(
    SocialPlatform platform, {
    required List<String> media,
    String? content,
    bool isOpenBrowser = true,
    VoidCallback? onAppNotInstalled,
  });
}
