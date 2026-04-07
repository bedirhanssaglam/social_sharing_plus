import 'package:flutter_test/flutter_test.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';
import 'package:social_sharing_plus/src/social_sharing_plus_platform_interface.dart';

import 'mock_social_sharing_plus_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SocialSharingPlus', () {
    late MockSocialSharingPlusPlatform testPlatform;

    setUp(() {
      testPlatform = MockSocialSharingPlusPlatform();
      SocialSharingPlusPlatform.instance = testPlatform;
    });

    test(
        'shareToSocialMedia calls onAppNotInstalled if app is not installed and isOpenBrowser is false',
        () async {
      const socialPlatform = SocialPlatform.twitter;
      const content = 'Tweet this!';
      const isOpenBrowser = false;
      var appNotInstalledCalled = false;

      testPlatform.onShareToSocialMedia = (platform, content,
          {required isOpenBrowser, image, media, onAppNotInstalled}) async {
        if (platform == SocialPlatform.twitter && !isOpenBrowser) {
          onAppNotInstalled?.call();
        }
        return;
      };

      await SocialSharingPlus.shareToSocialMedia(
        socialPlatform,
        content,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: () {
          appNotInstalledCalled = true;
        },
      );

      expect(appNotInstalledCalled, isTrue);
      expect(appNotInstalledCalled, isA<bool>());
    });

    test(
        'shareToSocialMedia does not call onAppNotInstalled if isOpenBrowser is true',
        () async {
      const socialPlatform = SocialPlatform.twitter;
      const content = 'Share this photo!';
      var appNotInstalledCalled = false;

      testPlatform.onShareToSocialMedia = (platform, content,
          {required isOpenBrowser, image, media, onAppNotInstalled}) async {
        if (platform == SocialPlatform.twitter && !isOpenBrowser) {
          onAppNotInstalled?.call();
        }
        return;
      };

      await SocialSharingPlus.shareToSocialMedia(
        socialPlatform,
        content,
        onAppNotInstalled: () {
          appNotInstalledCalled = true;
        },
      );

      expect(appNotInstalledCalled, isFalse);
      expect(appNotInstalledCalled, isA<bool>());
    });

    test('shareToSocialMedia works without an image', () async {
      const socialPlatform = SocialPlatform.linkedin;
      const content = 'Professional update!';

      testPlatform.onShareToSocialMedia = (platform, content,
          {required isOpenBrowser, image, media, onAppNotInstalled}) async {
        expect(platform, socialPlatform);
        expect(content, allOf(isA<String>(), equals('Professional update!')));
        expect(image, isNull);
        expect(isOpenBrowser, isTrue);
        return;
      };

      await SocialSharingPlus.shareToSocialMedia(
        socialPlatform,
        content,
      );
    });

    test('shareToSocialMedia handles null image gracefully', () async {
      const socialPlatform = SocialPlatform.whatsapp;
      const content = 'Message on WhatsApp!';
      const isOpenBrowser = false;
      var appNotInstalledCalled = false;

      testPlatform.onShareToSocialMedia = (platform, content,
          {required isOpenBrowser, image, media, onAppNotInstalled}) async {
        if (platform == SocialPlatform.whatsapp && !isOpenBrowser) {
          onAppNotInstalled?.call();
        }
        return;
      };

      await SocialSharingPlus.shareToSocialMedia(
        socialPlatform,
        content,
        isOpenBrowser: isOpenBrowser,
        onAppNotInstalled: () {
          appNotInstalledCalled = true;
        },
      );

      expect(appNotInstalledCalled, isTrue);
    });

    test('shareToInstagramDirect forwards the message to the platform',
        () async {
      const message = 'Hello Instagram';

      testPlatform.onShareInstagramDirect = (
        directMessage, {
        isOpenBrowser = true,
        onAppNotInstalled,
      }) async {
        expect(directMessage, message);
        expect(isOpenBrowser, isTrue);
      };

      await SocialSharingPlus.shareToInstagramDirect(message);
    });

    test('shareToInstagramStory forwards all story arguments', () async {
      testPlatform.onShareInstagramStory = ({
        required appId,
        stickerImage,
        backgroundImage,
        backgroundVideo,
        backgroundTopColor,
        backgroundBottomColor,
        attributionURL,
        isOpenBrowser = true,
        onAppNotInstalled,
      }) async {
        expect(appId, '123');
        expect(stickerImage, 'sticker.png');
        expect(backgroundVideo, 'video.mp4');
        expect(backgroundTopColor, '#FFFFFF');
        expect(backgroundBottomColor, '#000000');
        expect(attributionURL, 'https://example.com');
        expect(isOpenBrowser, isFalse);
      };

      await SocialSharingPlus.shareToInstagramStory(
        appId: '123',
        stickerImage: 'sticker.png',
        backgroundVideo: 'video.mp4',
        backgroundTopColor: '#FFFFFF',
        backgroundBottomColor: '#000000',
        attributionURL: 'https://example.com',
        isOpenBrowser: false,
      );
    });
  });
}
