import 'dart:io' show Platform;

import 'package:flutter/material.dart';
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
  final TextEditingController _controller = TextEditingController();
  static const List<SocialPlatform> _platforms = SocialPlatform.values;

  final ImagePicker _picker = ImagePicker();
  String? _mediaPath;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) _mediaPath = pickedFile.path;
    });
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) _mediaPath = pickedFile.path;
    });
  }

  Future<void> _share(SocialPlatform platform) async {
    final String content = _controller.text;
    await SocialSharingPlus.shareToSocialMedia(
      platform,
      content,
      image: _mediaPath,
      media: _mediaPath,
      isOpenBrowser: true,
      onAppNotInstalled: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('${platform.name.capitalize} is not installed.'),
          ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Sharing Example'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a text',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 20),
                  if (Platform.isAndroid)
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: const Text('Pick Video'),
                    ),
                ],
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
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";
}
