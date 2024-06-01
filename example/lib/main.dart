import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SharePage(),
    );
  }
}

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  static const List<SocialPlatform> _platforms = SocialPlatform.values;

  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePath = pickedFile.path;
      }
    });
  }

  Future<void> _share(SocialPlatform platform) async {
    final String content = platform == SocialPlatform.facebook
        ? 'https://github.com/bedirhanssaglam'
        : 'Hello ${platform.name.capitalize}! This is my GitHub profile : https://github.com/bedirhanssaglam';

    try {
      await SocialSharingPlus.shareToSocialMedia(
        platform,
        content,
        image: _imagePath,
        isOpenBrowser: true,
        onAppNotInstalled: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text('${platform.name.capitalize} is not installed.'),
            ));
        },
      );
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Sharing Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ..._platforms.map(
              (SocialPlatform platform) => ElevatedButton(
                onPressed: () => _share(platform),
                child: Text('Share to ${platform.name.capitalize}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";
}
