//
//  PhotosCollectionVC.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 18.04.2021.
//

import UIKit

class PhotosCollectionVC: UICollectionViewController {
    
    var model: IModelPhotosVC
    var palette: PaletteProtocol
    var clousure: ((UIImage) -> Void)?
    var collectionViewDataSource: UICollectionViewDataSource?
    
    let spinner = Spinner()
    
    let numberOfCellInRow: CGFloat = 3
    let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // MARK: - init
    
    init?(model: IModelPhotosVC, palette: PaletteProtocol) {
        self.model = model
        self.palette = palette
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setData()
        collectionView.backgroundColor = palette.backgroundColor
    
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(PhotosVCHeader.self,
                                forSupplementaryViewOfKind: kind,
                                withReuseIdentifier: "photoHeader")
        collectionView.register(AvaCell.self, forCellWithReuseIdentifier: "avaCell")
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = self
    }
    
    deinit {
        var shouldLogTextAnalyzer = false
        if ProcessInfo.processInfo.environment["deinit_log"] == "verbose" {
            shouldLogTextAnalyzer = true
        }
        if shouldLogTextAnalyzer { print("Deinit PhotosCollectionVC") }
    }
    
    private func setData() {
        spinner.startAnimating()
        model.fetchURLs { [weak self] result in
            switch result {
            case .success(let imageURLs):
                self?.model.photos = imageURLs
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.spinner.stopAnimating()
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                ErrorAlert.show(error.localizedDescription) { [weak self] alert in
                    DispatchQueue.main.async {
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.bounds.width
        let screenWidthMinusInsets = screenWidth - (insets.left * (numberOfCellInRow + 1))
        let itemWidth = screenWidthMinusInsets / numberOfCellInRow
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionHeadersPinToVisibleBounds = true
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        spinner.isHidden = false
        spinner.startAnimating()
        let urlString = model.photos?[indexPath.row].largeImageURL
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.model.fetchImage(urlString: urlString) { image in
                DispatchQueue.main.async {
                    guard let selectedImage = image else { return }
                    self?.clousure?(selectedImage)
                    self?.spinner.stopAnimating()
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - Setup Constraints

extension PhotosCollectionVC {
    
    func setConstraints() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
