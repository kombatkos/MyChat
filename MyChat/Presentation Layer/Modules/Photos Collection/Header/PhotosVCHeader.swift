//
//  PhotosVCHeader.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 19.04.2021.
//

import UIKit

class PhotosVCHeader: UICollectionReusableView {
    
    var palette: PaletteProtocol?
    var closeButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSubviews()
        self.backgroundColor = palette?.tableViewHeaderFooterColor ?? .clear
        self.alpha = 0.95
    }
    
    func setSubviews() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        
        label.text = "Select Avatar"
        label.font = .boldSystemFont(ofSize: 28)
        
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16).isActive = true
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.setTitleColor(.darkGray, for: .highlighted)
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
