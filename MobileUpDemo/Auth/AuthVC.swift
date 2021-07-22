//
//  AuthVC.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import UIKit
import WebKit

class AuthVC: UIViewController {
    
    var webview: WKWebView!
    static var url: URL? {
        var components = URLComponents(string: "https://oauth.vk.com/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: "7909293"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.13")
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
            print(fragment.split(separator: "&").map({ str -> (String, String) in
                let values = str.split(separator: "=")
                return (String(values[0]), String(values[1]))
            }))
            /// TODO: save token
            dismiss(animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        /// TODO: обработать ошибк
        dismiss(animated: true, completion: nil)
    }
}
