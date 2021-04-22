//
//  ThemePickerButton.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import UIKit

class ThemePickerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        setImage(#imageLiteral(resourceName: "graySetting"), for: .normal)
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
