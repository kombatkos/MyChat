//
//  UIButton + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 25.04.2021.
//

import UIKit

extension UIButton {
    
    func jiggle() {
        let animation1 = CAKeyframeAnimation()
        animation1.keyPath = "transform.rotation.z"
        animation1.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation1.values = [0, -Double.pi / 10, +Double.pi / 10, 0]
        
        animation1.keyTimes = [0, 0.1, 0.9, 1]
        animation1.duration = 3 / 10
        
        let animation2 = CAKeyframeAnimation()
        animation2.keyPath = "transform.translation.x"
        animation2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation2.values = [0, -5, 5, 0]

        animation2.keyTimes = [0.0, 0.10, 0.50, 1.0]
        animation2.duration = 3 / 10

        let animation3 = CAKeyframeAnimation()
        animation3.keyPath = "transform.translation.y"
        animation3.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation3.values = [0, -5, 5, 0]

        animation3.keyTimes = [0.10, 0.25, 0.90, 1.0]
        animation3.duration = 3 / 10
        
        let group = CAAnimationGroup()
        group.duration = 3 / 10
        group.animations = [animation2, animation3, animation1]
        group.repeatCount = .infinity
//        group.autoreverses = true
        self.layer.add(group, forKey: nil)
    }
}
