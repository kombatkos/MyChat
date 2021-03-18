//
//  UIWindow + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 07.03.2021.
//

import UIKit

public extension UIWindow {
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}
