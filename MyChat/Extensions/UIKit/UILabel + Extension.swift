//
//  UILabel + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

extension UILabel {
    
    convenience init(font: UIFont? = .avenir20(), text: String, textColor: UIColor = .lightGray) {
        self.init()
        self.textColor = textColor
        self.font = font
        self.text = text
    }
    
}
