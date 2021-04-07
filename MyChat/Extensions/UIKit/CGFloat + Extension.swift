//
//  CGFloat + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 01.04.2021.
//
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
