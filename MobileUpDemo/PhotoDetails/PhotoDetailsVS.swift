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
    }
}
