//
//  PhotoDetailsVS.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 24.07.2021.
//

import UIKit

class PhotoDetailsVS: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photoDate: Double!
    var image: UIImage!
    
    convenience init(image: UIImage, photoDate: Double) {
        self.init()
        self.photoDate = photoDate
        self.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date(timeIntervalSince1970: photoDate)
        let formater = DateFormatter()
        formater.dateFormat = "d MMMM yyyy"
        title = formater.string(from: date)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(savePhoto)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func savePhoto() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let save = UIAlertAction(title: "Save to the gallery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.saveCompletion), nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(save)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    @objc func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        /// TODO: уведомить пользователя
    }
}
