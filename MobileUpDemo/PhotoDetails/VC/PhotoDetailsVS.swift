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
            action: #selector(share)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func share() {
        
        guard let image = image else { return }
        
        // В задании сказано уведомить пользователя при сохранении
        let customItem = СustomActivity(
            title: Strings.saveWithNotification,
            image: UIImage(systemName: "square.and.arrow.down"))
        { sharedItems in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompletion), nil)
        }
        
        let shareSheet = UIActivityViewController(
            activityItems: [image],
            applicationActivities: [customItem]
        )
        present(shareSheet, animated: true)
    }
    
    @objc func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            let errorTitle = Strings.saveFailed
            let errorMessage = Strings.somethingWentWrongWithTryAgain
            errorAlert(title: errorTitle, message: errorMessage, retryAction: {
                UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.saveCompletion), nil)
            })
        } else {
            let successTitle = Strings.successSave
            let successMessage = Strings.photoSavedSuccessfully
            alert(title: successTitle, message: successMessage)
        }
    }
}
