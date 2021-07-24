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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = AlbumNetworkService.authURL else {
            print("Bad url")
            showError()
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
                print("Bad token response")
                showError()
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
        showError()
    }
}
