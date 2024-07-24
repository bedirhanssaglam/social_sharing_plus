# social_sharing_plus

`social_sharing_plus` is a Flutter plugin that allows you to share content, images and videos to various social media platforms like Facebook, Twitter, LinkedIn, WhatsApp, Reddit, and Telegram. This package provides a simple and unified interface for sharing across different apps, handling the nuances and differences of each platform.

## Table of contents

- [Setup](#setup)

- [Usage](#usage)

- [Properties](#properties)

- [Screenshots](#screenshots)

- [Dart Version](#dart-version)

- [Issues](#issues)

- [Contribute](#contribute)

- [Author](#author)

- [License](#license)

### Setup

`social_sharing_plus` is supported on Android and iOS platforms. On the Android side, queries are made with the package names of the respective apps. This requires the addition of some Android-specific code.

<details>
<summary>Android (click to expand)</summary>
  
**Add queries for app packages**
  
You need to add the following queries to your app's AndroidManifest.xml file to ensure proper redirection to the respective social media apps:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapp">

    <queries>
        <!-- Query for Facebook -->
        <package android:name="com.facebook.katana" />
        <!-- Query for Twitter -->
        <package android:name="com.twitter.android" />
        <!-- Query for LinkedIn -->
        <package android:name="com.linkedin.android" />
        <!-- Query for Reddit -->
        <package android:name="com.reddit.frontpage" />
        <!-- Query for WhatsApp -->
        <package android:name="com.whatsapp" />
        <!-- Query for Telegram -->
        <package android:name="org.telegram.messenger" />
    </queries>

    <application>
         <!-- ... -->
    </application>
</manifest>
```

**Media Sharing and Media Provider**

This provides a specific file provider so that it can share files with other applications. To provide this functionality, you need to create an XML folder under the `android>app>src>main>res` folder and name it `filepaths.xml`. Then add the following code to the `filepaths.xml` file:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <cache-path name="cache" path="." />
    <external-path name="external" path="." />
</paths>
```

This XML file specifies what types of files your file provider can provide. Then add a `<provider>` tag in your AndroidManifest.xml file like this:

```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/filepaths" />
</provider>
```

This `<provider>` tag specifies the authorization of your file provider and what file paths it provides. The `android:authorities` attribute specifies the identity of your file provider, and the `${applicationId}.fileprovider` value uses your application's credentials. This ensures the security of your application while allowing other applications to access files.

</details>

<details>
<summary>iOS (click to expand)</summary>

No special configuration is needed for iOS.

</details>

---

```yaml                    
dependencies:
  social_sharing_plus: <latest_version>    
```       

### Usage

```dart
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
```

## Properties

| Properties              | Required | Default                   | Description                                                                                                                                                                   |
| ----------------------- | -------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
|                                                                                                                                                                    |
| socialPlatform      | true     |                           | Platform you want to share on                                                                                                                                              |
| content        | true     |      | Any text you want to share                                                                                          |
| image                    | false     |      | The image you want to share                                                                                                 |
| media (NEW)                   | false     |      | The video you want to share                                                                                                 |
| isOpenBrowser             | false    | `true` | If the relevant application is not installed, it redirects to the link (browser) of the relevant application. |
| onAppNotInstalled          | false    |             | This method works if the application is not installed and the `isOpenBrowser` value is set to false. (For example: Showing a Snackbar like "The application is not installed on your device."...) |

### Screenshots

<p float="left">
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/273ab816-49f2-42e7-a73e-9535a5f73d15" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/7a56408d-fc44-4def-8bdf-b831923a5a1e" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/a2b5051d-9303-4eb7-a6f8-82615c1e340a" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/97b6e132-58b3-45bc-bff8-35f1ceedcd7b" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/b63be060-fa90-47b5-9f25-06ff31d3a1d9" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/ff960417-5627-4e90-a3c1-7a719868de62" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/231e2a6e-6f84-45af-aef8-97da6869ec6f" width=100" />
  <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/fafa227a-f89a-4cab-9b7f-2bd13daf7987" width=100" />
</p>

### Dart Version

```yaml
  sdk: '>=2.17.0 <4.0.0'
```

### Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/bedirhanssaglam/social_sharing_plus/issues) page.

### Contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/bedirhanssaglam/social_sharing_plus/pulls).

### Author

This social_sharing_plus plugin for Flutter is developed by [Bedirhan Sağlam](https://github.com/bedirhanssaglam). You can contact me at <bedirhansaglam270@gmail.com>

### License

MIT
