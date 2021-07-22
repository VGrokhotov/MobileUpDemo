//
//  AuthVC.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import UIKit
import WebKit

class AuthVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var webview: WKWebView!
    
    static var url: URL? {
        var components = URLComponents(string: "https://oauth.vk.com/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: "7909293"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        return components?.url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let url = AuthVC.url else {
            print("Bad url")
            /// TODO: обработать ошибку в completion
            dismiss(animated: true, completion: nil)
            return
        }
        
        webview = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        view.addSubview(webview)
        webview.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webview.frame = view.bounds
    }
    

}

extension AuthVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let fragment = webview.url?.fragment {
            var dict = [String: String]()
            fragment.split(separator: "&").forEach({ str in
                    let values = str.split(separator: "=")
                    dict[String(values[0])] = String(values[1])
                }
            )
            guard
                let token = dict["access_token"],
                let expiresInString = dict["expires_in"],
                let expiresIn = Double(expiresInString),
                let id = dict["user_id"]
            else {
                /// TODO: обработать ошибку
                return
            }
            let userInfo = UserInfo(token: token, expires: Date().timeIntervalSince1970 + expiresIn, id: id)
            activityIndicator.startAnimating()
            UserInfoStorage.shared.save(user: userInfo) { [weak self] in
                self?.activityIndicator.stopAnimating()
                guard let window = UIApplication.shared.windows.first else { return }
                let navigationController = UINavigationController()
                navigationController.setViewControllers([AlbumVC()], animated: false)
                self?.dismiss(animated: true, completion: nil)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        /// TODO: обработать ошибк
        dismiss(animated: true, completion: nil)
    }
}
