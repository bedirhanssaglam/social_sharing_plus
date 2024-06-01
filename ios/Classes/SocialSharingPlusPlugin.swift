import Flutter
import UIKit

public class SocialSharingPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_sharing_plus", binaryMessenger: registrar.messenger())
    let instance = SocialSharingPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

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
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func shareImageToSocialMedia(image: UIImage, result: @escaping FlutterResult) {
    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
    result(nil)
}


    private func shareToFacebook(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "fb://publish/profile/me?text=\(content)"
            let webUrlString = "https://www.facebook.com/sharer/sharer.php?u=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["image"] as? String, let image = UIImage(contentsOfFile: imageUri) {
            shareImageToSocialMedia(image: image, result: result)
        }
    }

    private func shareToTwitter(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "twitter://post?message=\(content)"
            let webUrlString = "https://x.com/intent/tweet?text=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["image"] as? String, let image = UIImage(contentsOfFile: imageUri) {
            shareImageToSocialMedia(image: image, result: result)
        }
    }

    private func shareToLinkedIn(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "linkedin://shareArticle?mini=true&url=\(content)"
            let webUrlString = "https://www.linkedin.com/sharing/share-offsite/?url=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    private func shareToWhatsApp(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "whatsapp://send?text=\(content)"
            let webUrlString = "https://api.whatsapp.com/send?text=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        } else if let imageUri = arguments["image"] as? String, let image = UIImage(contentsOfFile: imageUri) {
            shareImageToSocialMedia(image: image, result: result)
        }
    }

    private func shareToReddit(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "reddit://submit?url=\(content)"
            let webUrlString = "https://www.reddit.com/submit?title=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    private func shareToTelegram(arguments: [String: Any], result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let content = arguments["content"] as? String {
            let urlString = "tg://msg?text=\(content)"
            let webUrlString = "https://t.me/share/url?url=\(content)"
            openUrl(urlString: urlString, webUrlString: webUrlString, result: result, isOpenBrowser: isOpenBrowser)
        }
    }

    private func openUrl(urlString: String, webUrlString: String, result: @escaping FlutterResult, isOpenBrowser: Bool) {
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                result(nil)
            } else if isOpenBrowser, let webUrl = URL(string: webUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                result(nil)
            } else {
                result(FlutterError(code: "APP_NOT_INSTALLED", message: "APP_NOT_INSTALLED", details: nil))
            }
        } else {
            result(FlutterError(code: "URL_ERROR", message: "Invalid URL", details: nil))
        }
    }
}
