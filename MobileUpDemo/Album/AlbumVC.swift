//
//  AlbumVC.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import UIKit
import Localizer

class AlbumVC: UIViewController {

    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loadingView: LoadingReusableView?
    
    var data = [PhotoInfo]()
    var isLoading = false
    var offset = 0
    let gap = 20
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        getPhotos()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: "PhotoCell", bundle: nil),
            forCellWithReuseIdentifier: "PhotoCell"
        )
        collectionView.register(
            UINib(nibName: "LoadingReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "LoadingReusableView"
        )
    }
    
    func configureNavBar() {
        title = "Mobile Up Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: String(.en("Logout"), .ru("Выход")),
            style: .plain,
            target: self,
            action: #selector(logout)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func logout() {
        mainActivityIndicator.startAnimating()
        UserInfoStorage.shared.delete { [weak self] in
            self?.mainActivityIndicator.stopAnimating()
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = MainVC()
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    func getPhotos() {
        mainActivityIndicator.startAnimating()
        AlbumNetworkService.shared.getPhotosWith(offset: offset) { [weak self] photos in
            self?.count = photos.response.count
            self?.data = photos.response.items.map { photo in
                PhotoInfo(date: photo.date, size: photo.bestSize)
            }
            self?.mainActivityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        } errCompletion: { [weak self] error in
            print(error)
            guard let self = self else { return }
            self.errorAlert(
                title: String(.en("Error occurred!"), .ru("Произошла ошибка!")),
                message: String(.en("Network problem, please try again."), .ru("Проблемы с сетью, повторите попытку.")),
                retryAction: self.getPhotos
            )
            self.mainActivityIndicator.stopAnimating()
        }
    }
    
    func getNextPhotos() {
        if !isLoading {
            isLoading = true
            offset += gap
            AlbumNetworkService.shared.getPhotosWith(offset: offset) { [weak self] photos in
                self?.data.append(contentsOf:
                    photos.response.items.map { photo in
                        PhotoInfo(date: photo.date, size: photo.bestSize)
                    }
                )
                self?.isLoading = false
                self?.collectionView.reloadData()
            } errCompletion: { [weak self] error in
                print(error)
                guard let self = self else { return }
                self.errorAlert(
                    title: String(.en("Error occurred!"), .ru("Произошла ошибка!")),
                    message: String(.en("Network problem, please try again."), .ru("Проблемы с сетью, повторите попытку.")),
                    retryAction: self.getNextPhotos
                )
                self.isLoading = false
            }
        }
    }
}

extension AlbumVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell,
            let image = cell.imageView.image
        else { return }
        let vc = PhotoDetailsVS(image: image, photoDate: data[indexPath.row].date)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading || offset + gap >= count {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "LoadingReusableView",
                for: indexPath
            ) as! LoadingReusableView
            loadingView = footerView
            loadingView?.backgroundColor = UIColor.clear
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter && offset + gap < count {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offset + gap < count && indexPath.row == data.count - 1 && !self.isLoading {
            getNextPhotos()
        }
    }
}

extension AlbumVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = data[indexPath.row]
        
        let identifier = String(describing: PhotoCell.self)
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCell
        else { return PhotoCell() }
        
        cell.configure(with: photo)
        
        return cell
    }
}

extension AlbumVC: UICollectionViewDelegateFlowLayout {
    
    private static let sectionInsets = UIEdgeInsets(
        top: 0,
        left: 2,
        bottom: 0,
        right: 2
    )
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = AlbumVC.sectionInsets.left * (2 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return AlbumVC.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return AlbumVC.sectionInsets.left
    }
}
