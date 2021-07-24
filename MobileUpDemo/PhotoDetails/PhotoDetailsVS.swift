//
//  PhotoDetailsVS.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 24.07.2021.
//

import UIKit
import Localizer

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
        
        let save = UIAlertAction(title: String(.en("Save to the gallery"), .ru("Сохранить в галерею")), style: .default) { [weak self] _ in
            guard let self = self else { return }
            UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.saveCompletion), nil)
        }
        let cancel = UIAlertAction(title: String(.en("Cancel"), .ru("Отмена")) , style: .cancel)
        
        actionSheet.addAction(save)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    @objc func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            let errorTitle = String(.en("Save failed!"), .ru("Не удалось сохранить!"))
            let errorMessage = String(.en("Something went wrong, please, try again."), .ru("Что-то пошло не так, пожалуйста, попробуйте еще раз."))
            errorAlert(title: errorTitle, message: errorMessage, retryAction: {
                UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.saveCompletion), nil)
            })
        } else {
            let successTitle = String(.en("Success!"), .ru("Сохранено!"))
            let successMessage = String(.en("Photo saved successfully."), .ru("Фото было успешно сохранено."))
            alert(title: successTitle, message: successMessage)
        }
    }
}
