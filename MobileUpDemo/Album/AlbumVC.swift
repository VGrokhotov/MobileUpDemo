//
//  AlbumVC.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import UIKit

class AlbumVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mobile Up Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Выход",
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func logout() {
        activityIndicator.startAnimating()
        UserInfoStorage.shared.delete { [weak self] in
            self?.activityIndicator.stopAnimating()
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = MainVC()
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }

}
