//
//  PhotoCell.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 23.07.2021.
//

import UIKit
import SkeletonView
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var data: PhotoInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.isSkeletonable = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

extension PhotoCell: ConfigurableView {
    typealias ConfigurationModel = PhotoInfo
    
    func configure(with model: PhotoInfo) {
        imageView.image = nil
        imageView.showAnimatedGradientSkeleton()
        data = model
        let url = URL(string: model.size.url)
        imageView.kf.setImage(with: url) { [weak self] result in
            self?.imageView.hideSkeleton(transition: .crossDissolve(0.5))
        }
    }
}
