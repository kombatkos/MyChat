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
        self.backgroundColor = .clear
    }
    
    func setSubviews() {
        let blur = palette?.blurEfectStyle
        let blurView = UIVisualEffectView(effect: blur)
        if palette?.nameTheme == "night" {
            blurView.effect = UIBlurEffect(style: .dark)
        } else {
            blurView.effect = UIBlurEffect(style: .extraLight)
        }
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurView)
        
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        
        blurView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        if #available(iOS 13.0, *) {
            borderView.backgroundColor = .systemFill
        }
        borderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
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
