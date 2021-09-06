//
//  PhotoDetailsVS.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 24.07.2021.
//

import UIKit

class PhotoDetailsVS: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var data: [PhotoInfo]!
    var initialPhotoIndex: Int = 0
    var isfirstScroll = true
    
    convenience init(data: [PhotoInfo], initialPhotoIndex: Int) {
        self.init()
        self.data = data
        self.initialPhotoIndex = initialPhotoIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle(with: data[initialPhotoIndex].date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(share)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        mainCollectionView.isPagingEnabled = true
        configure(mainCollectionView)
        configure(bottomCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isfirstScroll {
            mainCollectionView.scrollToItem(at: IndexPath(row: initialPhotoIndex, section: 0), at: .centeredHorizontally, animated: false)
            bottomCollectionView.scrollToItem(at: IndexPath(row: initialPhotoIndex, section: 0), at: .centeredHorizontally, animated: false)
            isfirstScroll = false
        }
    }
    
    func setTitle(with date: Double) {
        let date = Date(timeIntervalSince1970: date)
        let formater = DateFormatter()
        formater.dateFormat = "d MMMM yyyy"
        title = formater.string(from: date)
    }
    
    func configure(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: "PhotoCell", bundle: nil),
            forCellWithReuseIdentifier: "PhotoCell"
        )
    }
    
    @objc func share() {
        
        guard
            let cell = mainCollectionView.visibleCells.first as? PhotoCell,
            let image = cell.imageView.image
        else { return }
        
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
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompletion), nil)
            })
        } else {
            let successTitle = Strings.successSave
            let successMessage = Strings.photoSavedSuccessfully
            alert(title: successTitle, message: successMessage)
        }
    }
}

extension PhotoDetailsVS: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == self.bottomCollectionView {
            mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension PhotoDetailsVS: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = data[indexPath.row]
        
        let identifier = String(describing: PhotoCell.self)
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCell
        else { return PhotoCell() }
        
        // Фото закешированы, поэтому повторной загрузки не будет
        cell.configure(with: photo)
        
        if collectionView == mainCollectionView {
            setTitle(with: data[indexPath.row].date)
        }
        
        return cell
    }
}


extension PhotoDetailsVS: UICollectionViewDelegateFlowLayout {
    
    private static let mainSectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private static let bottomSectionInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = collectionView == self.mainCollectionView ? 0 : PhotoDetailsVS.bottomSectionInsets.left * 8
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = collectionView == self.mainCollectionView ? availableWidth : availableWidth / 7
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView == self.mainCollectionView ? PhotoDetailsVS.mainSectionInsets : PhotoDetailsVS.bottomSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.mainCollectionView ? PhotoDetailsVS.mainSectionInsets.left : PhotoDetailsVS.bottomSectionInsets.left
    }
}
