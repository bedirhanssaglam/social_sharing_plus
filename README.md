# social_sharing_plus

`social_sharing_plus` is a Flutter plugin that allows you to share content, images and videos to various social media platforms like Facebook, Twitter, LinkedIn, WhatsApp, Reddit, and Telegram. This package provides a simple and unified interface for sharing across different apps, handling the nuances and differences of each platform.

🚀 **Exciting News!** You can now share multiple images and videos with text(optional)! 📸🎥

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
  social_sharing_plus: ^1.2.1
```       

### Usage

```dart
import 'package:social_sharing_plus/social_sharing_plus.dart';

static const SocialPlatform platform = SocialPlatform.facebook;
String? _mediaPath; // add image or video path
List<String> _mediaPaths = []; // add image or video paths
bool isMultipleShare = true;

isMultipleShare
    ? await SocialSharingPlus.shareToSocialMediaWithMultipleMedia(
        platform,
        media: _mediaPaths,
        content: content,
        isOpenBrowser: false,
        onAppNotInstalled: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text('${platform.name.capitalize} is not installed.'),
            ));
        },
      )
    : await SocialSharingPlus.shareToSocialMedia(
        platform,
        content,
        media: _mediaPath,
        isOpenBrowser: true,
      );
```

## Properties

- `shareToSocialMedia`:

| Properties              | Required | Default                   | Description                                                                                                                                                                   |
| ----------------------- | -------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
|                                                                                                                                                                    |
| socialPlatform      | true     |                           | Platform you want to share on                                                                                                                                              |
| content        | true     |      | Any text you want to share                                                                                           
| media                   | false     |      | The image or video you want to share                                                                                                 |
| isOpenBrowser             | false    | `true` | If the relevant application is not installed, it redirects to the link (browser) of the relevant application. |
| onAppNotInstalled          | false    |             | This method works if the application is not installed and the `isOpenBrowser` value is set to false. (For example: Showing a Snackbar like "The application is not installed on your device."...) |

- `shareToSocialMediaWithMultipleMedia`:

| Properties              | Required | Default                   | Description                                                                                                                                                                   |
| ----------------------- | -------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
|                                                                                                                                                                    |
| socialPlatform      | true     |                           | Platform you want to share on                                                                                                                                              |
| content        | false     |      | Any text you want to share                                                                                           
| media                   | true     |      | The image or video you want to share                                                                                                 |
| isOpenBrowser             | false    | `true` | If the relevant application is not installed, it redirects to the link (browser) of the relevant application. |
| onAppNotInstalled          | false    |             | This method works if the application is not installed and the `isOpenBrowser` value is set to false. (For example: Showing a Snackbar like "The application is not installed on your device."...) |

### Screenshots

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/880ffe55-335f-4214-bafa-6a25843c9807" width="100"/>
                </a>
            </td>            
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/126a422a-2bb0-4f4d-8e6b-4779944de4bc" width="100"/>
                </a>
            </td>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/a2b5051d-9303-4eb7-a6f8-82615c1e340a" width="100" />
                </a>
            </td>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/096a4daa-3cc0-4d17-b627-9b0f82c11108" width="100" />
                </a>
            </td>          
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/517f094d-1005-4a2d-93cc-995534688db2" width="100" />
                </a>
            </td>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/b63be060-fa90-47b5-9f25-06ff31d3a1d9" width="100" />
                </a>
            </td> 
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/4b9ecdba-6bcd-4d11-a3e9-8a252b9a4d8b" width="100" />
                </a>
            </td>    
        </tr>
        <tr>        
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/f9ddef3e-27f5-45b5-8c53-53d3813ffe3d" width="100"/>
                </a>
            </td>             
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/ff960417-5627-4e90-a3c1-7a719868de62" width="100"/>
                </a>
            </td>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/231e2a6e-6f84-45af-aef8-97da6869ec6f" width="100" />
                </a>
            </td>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/d0aaf839-0c6a-46cf-be1d-acf94f4e24d7" width="100" />
                </a>
            </td>    
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/bedirhanssaglam/social_sharing_plus/assets/105479937/fafa227a-f89a-4cab-9b7f-2bd13daf7987" width="100" />
                </a>
            </td>
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/f7831ed7-5d1c-4fbb-b8ca-181d6c59f6ac" width="100" />
                </a>
            </td>      
            <td style="text-align: center">
                <a>
                    <img src="https://github.com/user-attachments/assets/80dee235-2d57-4c71-9920-018c3795b726" width="100" />
                </a>
            </td>
        </tr>     
    </table>
</div>

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
