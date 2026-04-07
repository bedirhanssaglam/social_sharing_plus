/// Enum representing the various social media platforms.
enum SocialPlatform {
  /// Represents Facebook.
  ///
  /// For [iOS], only URL sharing is supported.
  ///
  /// For [Android], you can share both text, images and video in groups, as a profile picture, as a post/story or message.
  facebook,

  /// Represents LinkedIn.
  ///
  /// For [iOS], only text sharing is supported.
  ///
  /// For [Android], you can share both text, images and video in groups, as a post or message.
  linkedin,

  /// Represents Reddit.
  ///
  /// For [iOS], only text sharing is supported.
  ///
  /// For [Android], you can share both text, images and video as a post.
  reddit,

  /// Represents Reddit.
  ///
  /// For [iOS], only text sharing is supported.
  ///
  /// For [Android], you can share both text, images and video in groups, as a tweet or message.
  twitter,

  /// Represents WhatsApp.
  ///
  /// For [iOS], only text sharing is supported.
  ///
  /// For [Android], you can share both text, images and videos.
  whatsapp,

  /// Represents Telegram.
  ///
  /// For [iOS], only text sharing is supported.
  ///
  /// For [Android], you can share both text, images and videos.
  telegram,

  /// Represents Instagram.
  ///
  /// For [iOS], generic media sharing uses Instagram's library flow and
  /// requires photo library access. Use the dedicated Instagram methods for
  /// Direct, Feed, Reels, and Stories features.
  ///
  /// For [Android], you can share both text, images and videos.
  instagram;

  /// Returns the method name corresponding to each social media platform.
  String get methodName {
    switch (this) {
      case SocialPlatform.facebook:
        return 'shareToFacebook';
      case SocialPlatform.linkedin:
        return 'shareToLinkedIn';
      case SocialPlatform.reddit:
        return 'shareToReddit';
      case SocialPlatform.twitter:
        return 'shareToTwitter';
      case SocialPlatform.whatsapp:
        return 'shareToWhatsApp';
      case SocialPlatform.telegram:
        return 'shareToTelegram';
      case SocialPlatform.instagram:
        return 'shareToInstagram';
    }
  }
}
