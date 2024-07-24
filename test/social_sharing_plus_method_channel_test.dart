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
        'shareToSocialMedia calls the platform interface with correct parameters',
        () async {
      const socialPlatform = SocialPlatform.facebook;
      const content = 'Check this out!';
      const image = 'image_path.png';

      testPlatform.onShareToSocialMedia = (platform, content,
          {required isOpenBrowser, image, media, onAppNotInstalled}) async {
        expect(platform, socialPlatform);
        expect(content, allOf(isA<String>(), contains('Check')));
        expect(content, equalsIgnoringCase('check this out!'));
        expect(image, 'image_path.png');
        expect(isOpenBrowser, isTrue);
        expect(
          isOpenBrowser,
          isA<bool>().having(
            (bool value) => value,
            'isOpenBrowser should be true',
            isTrue,
          ),
        );
        return;
      };

      await SocialSharingPlus.shareToSocialMedia(
        socialPlatform,
        content,
        image: image,
      );
    });

    test(
        'shareToSocialMedia calls onAppNotInstalled if app is not installed and isOpenBrowser is false',
        () async {
      const socialPlatform = SocialPlatform.twitter;
      const content = 'Tweet this!';
      const image = 'image_path.png';
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
        image: image,
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
      const image = 'image_path.png';
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
        image: image,
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

    test('shareToSocialMedia without onAppNotInstalled callback', () async {
      const socialPlatform = SocialPlatform.facebook;
      const content = 'Share this!';
      const image = 'snap_image.png';
      const isOpenBrowser = false;

      testPlatform.onShareToSocialMedia = (platform, content,
          {required isOpenBrowser, image, media, onAppNotInstalled}) async {
        expect(platform, socialPlatform);
        expect(content, anyOf(isA<String>(), contains('Snap')));
        expect(image, endsWith('snap_image.png'));
        expect(isOpenBrowser, isFalse);
        return;
      };

      await SocialSharingPlus.shareToSocialMedia(
        socialPlatform,
        content,
        image: image,
        isOpenBrowser: isOpenBrowser,
      );
    });

    test('shareToSocialMedia with different social platforms', () async {
      final platforms = [
        SocialPlatform.facebook,
        SocialPlatform.twitter,
        SocialPlatform.reddit,
        SocialPlatform.linkedin,
        SocialPlatform.whatsapp,
        SocialPlatform.telegram,
      ];

      for (final platform in platforms) {
        testPlatform.onShareToSocialMedia = (socialPlatform, content,
            {required isOpenBrowser, image, media, onAppNotInstalled}) async {
          expect(socialPlatform, platform);
          expect(content, contains(platform.name));
          expect(content, isA<String>());
          expect(image, startsWith('image_'));
          expect(image, isNotNull);
          expect(isOpenBrowser, isFalse);
          return;
        };

        await SocialSharingPlus.shareToSocialMedia(
          platform,
          'Sharing on ${platform.name}',
          image: 'image_${platform.name}.png',
          isOpenBrowser: false,
        );
      }
    });
  });
}
