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
        
        configureNavBar()
        
        activityIndicator.startAnimating()
        AlbumNetworkService.shared.getPhotosWith(offset: 0) { [weak self] photos in
            photos.response.items.forEach { photo in
                print(photo.bestSize)
            }
            self?.activityIndicator.stopAnimating()
        } errCompletion: { [weak self] error in
            /// TODO: обработать ошибку
            print(error)
            self?.activityIndicator.stopAnimating()
        }

    }
    
    func configureNavBar() {
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
