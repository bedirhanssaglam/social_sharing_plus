import Flutter
import Photos
import UIKit

public class SocialSharingPlusPlugin: NSObject, FlutterPlugin {
    
    // MARK: - FlutterPlugin Protocol Methods
    
    /// Registers the plugin with the Flutter engine.
    ///
    /// - Parameters:
    ///   - registrar: FlutterPluginRegistrar object.
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "social_sharing_plus", binaryMessenger: registrar.messenger())
        let instance = SocialSharingPlusPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // MARK: - Method Call Handler
    
    /// Handles method calls from Flutter.
    ///
    /// - Parameters:
    ///   - call: Flutter method call object.
    ///   - result: FlutterResult object to complete the call.
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any] else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Invalid arguments", details: nil))
            return
        }
        
        let isOpenBrowser = arguments["isOpenBrowser"] as? Bool ?? false

        switch call.method {
        case "shareToFacebook":
            shareToFacebook(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "shareToTwitter":
            shareToTwitter(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "shareToLinkedIn":
            shareToLinkedIn(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "shareToWhatsApp":
            shareToWhatsApp(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "shareToReddit":
            shareToReddit(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "shareToTelegram":
            shareToTelegram(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "shareToInstagram":
            shareToInstagram(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "instagramDirect":
            shareInstagramDirect(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "instagramFeed":
            shareInstagramFeed(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "instagramFeedMultiple":
            shareInstagramFeedMultiple(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "instagramReels":
            shareInstagramReels(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        case "instagramStory":
            shareInstagramStory(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Share Methods
    
    /// Shares content to Facebook.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content and image URIs.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToFacebook(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String, let imageUri = arguments["media"] as? String {
            shareContentAndImageToSpecificApp(content: content, imageUri: imageUri, appUrlScheme: "fb://publish/profile/me?text=\(content)", webUrlString: "https://www.facebook.com/sharer/sharer.php?u=\(content)", result: result, isOpenBrowser: isOpenBrowser)
        } else if let content = arguments["content"] as? String {
            let urlString = "fb://publish/profile/me?text=\(content)"
            let webUrlString = "https://www.facebook.com/sharer/sharer.php?u=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["media"] as? String {
            shareImageToSpecificApp(imageUri: imageUri, appUrlScheme: "fb://", result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    /// Shares content to Twitter.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content and image URIs.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToTwitter(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String, let imageUri = arguments["media"] as? String {
            shareContentAndImageToSpecificApp(content: content, imageUri: imageUri, appUrlScheme: "twitter://post?message=\(content)", webUrlString: "https://x.com/intent/tweet?text=\(content)", result: result, isOpenBrowser: isOpenBrowser)
        } else if let content = arguments["content"] as? String {
            let urlString = "twitter://post?message=\(content)"
            let webUrlString = "https://x.com/intent/tweet?text=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["media"] as? String {
            shareImageToSpecificApp(imageUri: imageUri, appUrlScheme: "twitter://", result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    /// Shares content to LinkedIn.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content URI.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToLinkedIn(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "linkedin://shareArticle?mini=true&url=\(content)"
            let webUrlString = "https://www.linkedin.com/sharing/share-offsite/?url=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    /// Shares content to WhatsApp.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content and image URIs.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToWhatsApp(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String, let imageUri = arguments["media"] as? String {
            shareContentAndImageToSpecificApp(content: content, imageUri: imageUri, appUrlScheme: "whatsapp://send?text=\(content)", webUrlString: "https://api.whatsapp.com/send?text=\(content)", result: result, isOpenBrowser: isOpenBrowser)
        } else if let content = arguments["content"] as? String {
            let urlString = "whatsapp://send?text=\(content)"
            let webUrlString = "https://api.whatsapp.com/send?text=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["media"] as? String {
            shareImageToSpecificApp(imageUri: imageUri, appUrlScheme: "whatsapp://", result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    /// Shares content to Reddit.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content URI.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToReddit(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "reddit://submit?url=\(content)"
            let webUrlString = "https://www.reddit.com/submit?title=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    /// Shares content to Telegram.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content and image URIs.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToTelegram(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String, let imageUri = arguments["media"] as? String {
            shareContentAndImageToSpecificApp(content: content, imageUri: imageUri, appUrlScheme: "tg://msg?text=\(content)", webUrlString: "https://t.me/share/url?url=\(content)", result: result, isOpenBrowser: isOpenBrowser)
        } else if let content = arguments["content"] as? String {
            let urlString = "tg://msg?text=\(content)"
            let webUrlString = "https://t.me/share/url?url=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["media"] as? String {
            shareImageToSpecificApp(imageUri: imageUri, appUrlScheme: "tg://", result: result, isOpenBrowser: isOpenBrowser)
        }
    }


    /// Shares content to Instagram.
    ///
    /// - Parameters:
    ///   - arguments: Arguments dictionary containing content and image URIs.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareToInstagram(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        let mediaPaths = extractInstagramFilePaths(from: arguments)

        if mediaPaths.count > 1 {
            shareInstagramFeedMultiple(arguments: arguments, result: result, isOpenBrowser: isOpenBrowser)
        } else if let mediaPath = mediaPaths.first {
            shareInstagramFeed(filePath: mediaPath, result: result, isOpenBrowser: isOpenBrowser)
        } else if let content = arguments["content"] as? String, !content.isEmpty {
            shareInstagramDirect(message: content, result: result, isOpenBrowser: isOpenBrowser)
        } else {
            openUrl(
                urlString: "instagram://app",
                webUrlString: "https://www.instagram.com/",
                result: result,
                isOpenBrowser: isOpenBrowser
            )
        }
    }

    private func shareInstagramDirect(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        let message = (arguments["message"] as? String) ?? (arguments["content"] as? String) ?? ""

        if message.isEmpty {
            openUrl(
                urlString: "instagram://app",
                webUrlString: "https://www.instagram.com/",
                result: result,
                isOpenBrowser: isOpenBrowser
            )
            return
        }

        shareInstagramDirect(message: message, result: result, isOpenBrowser: isOpenBrowser)
    }

    private func shareInstagramDirect(message: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        guard let encodedContent = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let instagramShareUrl = URL(string: "instagram://sharesheet?text=\(encodedContent)") else {
            result(FlutterError(code: "URL_ERROR", message: "Invalid Instagram share URL", details: nil))
            return
        }

        if UIApplication.shared.canOpenURL(instagramShareUrl) {
            UIApplication.shared.open(instagramShareUrl, options: [:], completionHandler: nil)
            result(nil)
        } else if openInstagramWebIfNeeded(result: result, isOpenBrowser: isOpenBrowser) {
            return
        } else {
            result(FlutterError(code: "APP_NOT_INSTALLED", message: "Instagram app is not installed on your device", details: nil))
        }
    }

    private func shareInstagramFeed(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        guard let filePath = extractInstagramFilePath(from: arguments) else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Instagram feed sharing requires a valid filePath", details: nil))
            return
        }

        shareInstagramFeed(filePath: filePath, result: result, isOpenBrowser: isOpenBrowser)
    }

    private func shareInstagramFeed(filePath: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        shareMediaToInstagram(mediaPath: filePath, result: result, isOpenBrowser: isOpenBrowser)
    }

    private func shareInstagramFeedMultiple(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        let filePaths = extractInstagramFilePaths(from: arguments)

        guard let firstFilePath = filePaths.first else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Instagram feed multiple sharing requires at least one valid filePath", details: nil))
            return
        }

        // Instagram's iOS library flow accepts a single local identifier. Mirror the
        // reference package and use the first valid file for feed sharing.
        shareInstagramFeed(filePath: firstFilePath, result: result, isOpenBrowser: isOpenBrowser)
    }

    private func shareInstagramReels(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        let videoPath = (arguments["videoPath"] as? String) ?? extractInstagramFilePath(from: arguments)

        guard let videoPath, !videoPath.isEmpty else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Instagram Reels sharing requires a valid videoPath", details: nil))
            return
        }

        let videoUrl = URL(fileURLWithPath: videoPath)
        guard isInstagramVideoFile(videoUrl) else {
            result(FlutterError(code: "VIDEO_ERROR", message: "Instagram Reels sharing requires a video file", details: nil))
            return
        }

        shareMediaToInstagram(mediaPath: videoPath, result: result, isOpenBrowser: isOpenBrowser)
    }

    private func shareInstagramStory(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        let appId = arguments["appId"] as? String ?? ""

        guard !appId.isEmpty else {
            result(FlutterError(code: "ARGUMENT_ERROR", message: "Instagram Stories sharing requires an appId", details: nil))
            return
        }

        guard let encodedAppId = appId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let storyUrl = URL(string: "instagram-stories://share?source_application=\(encodedAppId)") else {
            result(FlutterError(code: "URL_ERROR", message: "Invalid Instagram Stories URL", details: nil))
            return
        }

        guard UIApplication.shared.canOpenURL(storyUrl) else {
            if openInstagramWebIfNeeded(result: result, isOpenBrowser: isOpenBrowser) {
                return
            }

            result(FlutterError(code: "APP_NOT_INSTALLED", message: "Instagram app is not installed on your device", details: nil))
            return
        }

        var item: [String: Any] = [:]

        if let attributionURL = arguments["attributionURL"] as? String, !attributionURL.isEmpty {
            item["com.instagram.sharedSticker.attributionURL"] = attributionURL
        }

        if let backgroundImagePath = arguments["backgroundImage"] as? String,
           let image = UIImage(contentsOfFile: backgroundImagePath) {
            item["com.instagram.sharedSticker.backgroundImage"] = image
        }

        if let backgroundVideoPath = arguments["backgroundVideo"] as? String, !backgroundVideoPath.isEmpty {
            let videoUrl = URL(fileURLWithPath: backgroundVideoPath)
            if let data = try? Data(contentsOf: videoUrl) {
                item["com.instagram.sharedSticker.backgroundVideo"] = data
            }
        }

        if let stickerImagePath = arguments["stickerImage"] as? String,
           let stickerContent = instagramStickerContent(from: stickerImagePath) {
            item["com.instagram.sharedSticker.stickerImage"] = stickerContent
        }

        if let backgroundTopColor = arguments["backgroundTopColor"] as? String, !backgroundTopColor.isEmpty {
            item["com.instagram.sharedSticker.backgroundTopColor"] = backgroundTopColor
        }

        if let backgroundBottomColor = arguments["backgroundBottomColor"] as? String, !backgroundBottomColor.isEmpty {
            item["com.instagram.sharedSticker.backgroundBottomColor"] = backgroundBottomColor
        }

        let options: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(300),
        ]
        UIPasteboard.general.setItems([item], options: options)

        UIApplication.shared.open(storyUrl, options: [:]) { success in
            if success {
                result(nil)
            } else {
                result(FlutterError(code: "OPEN_INSTAGRAM_ERROR", message: "Failed to open Instagram Stories", details: nil))
            }
        }
    }

    private func extractInstagramFilePath(from arguments: [String: Any]) -> String? {
        extractInstagramFilePaths(from: arguments).first
    }

    private func extractInstagramFilePaths(from arguments: [String: Any]) -> [String] {
        if let filePath = arguments["filePath"] as? String, !filePath.isEmpty {
            return [filePath]
        }

        if let filePaths = arguments["filePaths"] as? [String] {
            return filePaths.filter { !$0.isEmpty }
        }

        if let mediaPath = arguments["media"] as? String, !mediaPath.isEmpty {
            return [mediaPath]
        }

        if let mediaPaths = arguments["media"] as? [String] {
            return mediaPaths.filter { !$0.isEmpty }
        }

        if let mediaPaths = arguments["media"] as? [Any] {
            return mediaPaths.compactMap { $0 as? String }.filter { !$0.isEmpty }
        }

        return []
    }

    private func openInstagramWebIfNeeded(result: @escaping FlutterResult, isOpenBrowser: Bool) -> Bool {
        guard isOpenBrowser, let webUrl = URL(string: "https://www.instagram.com/") else {
            return false
        }

        UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        result(nil)
        return true
    }

    private func shareMediaToInstagram(mediaPath: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        guard let instagramAppUrl = URL(string: "instagram://app"),
              UIApplication.shared.canOpenURL(instagramAppUrl) else {
            if openInstagramWebIfNeeded(result: result, isOpenBrowser: isOpenBrowser) {
                return
            }

            result(FlutterError(code: "APP_NOT_INSTALLED", message: "Instagram app is not installed on your device", details: nil))
            return
        }

        let fileUrl = URL(fileURLWithPath: mediaPath)
        requestInstagramPhotoLibraryAccess { isAuthorized in
            guard isAuthorized else {
                result(FlutterError(code: "PHOTO_LIBRARY_PERMISSION_DENIED", message: "Photo library access is required to share media to Instagram on iOS", details: nil))
                return
            }

            self.saveInstagramMediaAndOpenLibrary(fileUrl: fileUrl, result: result)
        }
    }

    private func requestInstagramPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized, .limited:
                completion(true)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized || newStatus == .limited)
                    }
                }
            default:
                completion(false)
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                completion(true)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized)
                    }
                }
            default:
                completion(false)
            }
        }
    }

    private func saveInstagramMediaAndOpenLibrary(fileUrl: URL, result: @escaping FlutterResult) {
        var localIdentifier: String?
        var canCreateAsset = false

        PHPhotoLibrary.shared().performChanges({
            if self.isInstagramVideoFile(fileUrl) {
                if let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl) {
                    localIdentifier = request.placeholderForCreatedAsset?.localIdentifier
                    canCreateAsset = true
                }
            } else if let image = UIImage(contentsOfFile: fileUrl.path) {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                localIdentifier = request.placeholderForCreatedAsset?.localIdentifier
                canCreateAsset = true
            }
        }) { success, error in
            DispatchQueue.main.async {
                guard canCreateAsset else {
                    result(FlutterError(code: "MEDIA_ERROR", message: "Invalid Instagram media path", details: nil))
                    return
                }

                guard success, let localIdentifier else {
                    result(FlutterError(code: "PHOTO_LIBRARY_ERROR", message: error?.localizedDescription ?? "Unable to save media for Instagram sharing", details: nil))
                    return
                }

                self.openInstagramLibrary(localIdentifier: localIdentifier, result: result)
            }
        }
    }

    private func openInstagramLibrary(localIdentifier: String, result: @escaping FlutterResult) {
        var components = URLComponents()
        components.scheme = "instagram"
        components.host = "library"
        components.queryItems = [URLQueryItem(name: "LocalIdentifier", value: localIdentifier)]

        guard let instagramLibraryUrl = components.url else {
            result(FlutterError(code: "URL_ERROR", message: "Invalid Instagram library URL", details: nil))
            return
        }

        UIApplication.shared.open(instagramLibraryUrl, options: [:]) { success in
            if success {
                result(nil)
            } else {
                result(FlutterError(code: "OPEN_INSTAGRAM_ERROR", message: "Failed to open Instagram library", details: nil))
            }
        }
    }

    private func isInstagramVideoFile(_ fileUrl: URL) -> Bool {
        let videoExtensions = ["mp4", "mov", "avi", "m4v", "mkv"]
        return videoExtensions.contains(fileUrl.pathExtension.lowercased())
    }

    private func instagramStickerContent(from path: String) -> Any? {
        let fileUrl = URL(fileURLWithPath: path)
        if fileUrl.pathExtension.lowercased() == "gif" {
            return try? Data(contentsOf: fileUrl)
        }

        return UIImage(contentsOfFile: path)
    }
    
    // MARK: - URL Handling
    
    /// Opens the specified URL.
    ///
    /// - Parameters:
    ///   - urlString: URL string to open.
    ///   - webUrlString: Web URL string to open if app URL is not available.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func openUrl(urlString: String, webUrlString: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                result(nil)
            } else if isOpenBrowser, let webUrl = URL(string: webUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                result(nil)
            } else {
                result(FlutterError(code: "APP_NOT_INSTALLED", message: "App not installed and browser option is not enabled", details: nil))
            }
        } else {
            result(FlutterError(code: "URL_ERROR", message: "Invalid URL", details: nil))
        }
    }
    
    // MARK: - Image Sharing
    
    /// Shares an image to a specific app.
    ///
    /// - Parameters:
    ///   - imageUri: Image file URI.
    ///   - appUrlScheme: App URL scheme to open.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareImageToSpecificApp(imageUri: String, appUrlScheme: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        guard let image = UIImage(contentsOfFile: imageUri) else {
            result(FlutterError(code: "IMAGE_ERROR", message: "Invalid image path", details: nil))
            return
        }
        guard let imageData = image.pngData() else {
            result(FlutterError(code: "IMAGE_DATA_ERROR", message: "Unable to get image data", details: nil))
            return
        }

        let pasteboard = UIPasteboard.general
        pasteboard.setData(imageData, forPasteboardType: "public.png")

        let urlString = "\(appUrlScheme)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            result(nil)
        } else if isOpenBrowser {
            result(FlutterError(code: "APP_NOT_INSTALLED", message: "App not installed and browser option is not enabled", details: nil))
        } else {
            result(FlutterError(code: "APP_NOT_INSTALLED", message: "App not installed", details: nil))
        }
    }

    /// Shares content and image to a specific app.
    ///
    /// - Parameters:
    ///   - content: Content string to share.
    ///   - imageUri: Image file URI.
    ///   - appUrlScheme: App URL scheme to open.
    ///   - webUrlString: Web URL string to open if app URL is not available.
    ///   - result: FlutterResult object to complete the call.
    ///   - isOpenBrowser: Flag indicating whether to open in browser if app not installed.
    private func shareContentAndImageToSpecificApp(content: String, imageUri: String, appUrlScheme: String, webUrlString: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        guard let image = UIImage(contentsOfFile: imageUri) else {
            result(FlutterError(code: "IMAGE_ERROR", message: "Invalid image path", details: nil))
            return
        }
        guard let imageData = image.pngData() else {
            result(FlutterError(code: "IMAGE_DATA_ERROR", message: "Unable to get image data", details: nil))
            return
        }

        let pasteboard = UIPasteboard.general
        pasteboard.setData(imageData, forPasteboardType: "public.png")

        var urlString = "\(appUrlScheme)"
        if appUrlScheme.contains("twitter://") {
            urlString += "post?message=\(content)"
        } else if appUrlScheme.contains("fb://") {
            urlString += "publish/profile/me?text=\(content)"
        } else if appUrlScheme.contains("whatsapp://") {
            urlString += "send?text=\(content)"
        } else if appUrlScheme.contains("tg://") {
            urlString += "msg?text=\(content)"
        }

        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            result(nil)
        } else if isOpenBrowser, let webUrl = URL(string: webUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
            result(nil)
        } else {
            result(FlutterError(code: "APP_NOT_INSTALLED", message: "App not installed and browser option is not enabled", details: nil))
        }
    }
}
