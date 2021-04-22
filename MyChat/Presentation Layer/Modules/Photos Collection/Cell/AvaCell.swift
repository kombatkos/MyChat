//
//  AvaCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 18.04.2021.
//

import UIKit

class AvaCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var palette: PaletteProtocol?
    
    convenience init(palette: PaletteProtocol?) {
        self.init()
        self.palette = palette
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        themeCell(theme: palette?.nameTheme)
    }
    
    func themeCell(theme: String?) {
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 3, height: 3)
        if theme == "night" {
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.red.cgColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.2
            layer.shadowColor = UIColor.white.cgColor
        } else {
            layer.borderWidth = 0.3
            layer.borderColor = UIColor.black.cgColor
            layer.shadowRadius = 10
            layer.shadowOpacity = 0.5
            layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    func setupConstraint() {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
