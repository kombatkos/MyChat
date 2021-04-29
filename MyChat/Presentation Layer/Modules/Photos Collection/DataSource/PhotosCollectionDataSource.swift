//
//  PhotosCollectionDataSource.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.04.2021.
//

import UIKit

class PhotosCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    let model: IModelPhotosVC
    let palette: PaletteProtocol
    weak var presentationController: UICollectionViewController?
    
    init(model: IModelPhotosVC, palette: PaletteProtocol, presentationController: UICollectionViewController?) {
        self.model = model
        self.palette = palette
        self.presentationController = presentationController
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  model.photos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avaCell", for: indexPath) as? AvaCell else { return UICollectionViewCell() }
        
        cell.palette = palette
        let placeholderImage = palette.nameTheme == "night" ? #imageLiteral(resourceName: "placeholderImageDark") : #imageLiteral(resourceName: "placeholderImage")
        cell.imageView.image = placeholderImage
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            let urlString = self?.model.photos?[indexPath.row].webformatURL
            self?.model.fetchImage(urlString: urlString) { image in
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let kind = UICollectionView.elementKindSectionHeader
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "photoHeader", for: indexPath) as? PhotosVCHeader
        else { fatalError("failed to get header") }
        header.palette = self.palette
        header.closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        return header
    }
    
    @objc func closeVC() {
        presentationController.dismiss(animated: true, completion: nil)
    }
}
