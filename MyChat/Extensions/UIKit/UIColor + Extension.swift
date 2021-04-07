//
//  UIColor + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 01.04.2021.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 0.8)
    }
}
