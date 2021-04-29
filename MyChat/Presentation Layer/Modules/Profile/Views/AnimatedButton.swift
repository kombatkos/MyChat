//
//  AnimatedButton.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 28.04.2021.
//

import UIKit

class AnimatedButton: UIButton {
    
    var isAnimated = false
    private let duration: Double = 3.0
    
    func jiggle() {
        if !isAnimated { startAnimation() } else { stopAnimation() }
    }
    
    func startAnimation() {
        isAnimated = true
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [yAnimation(), xAnimation()]
        group.repeatCount = .infinity
        self.layer.add(group, forKey: nil)
    }
    
    func stopAnimation() {
        isAnimated = false
        let returnAnimation = CABasicAnimation(keyPath: "position")
        returnAnimation.fromValue = layer.presentation()?.position
        returnAnimation.toValue = layer.position
        returnAnimation.duration = duration
        returnAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        returnAnimation.fillMode = .both
        returnAnimation.isRemovedOnCompletion = true
        layer.add(returnAnimation, forKey: "return")
    }
    
    private func rotateAnimation() -> CAKeyframeAnimation {
        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotate.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        rotate.values = [0, -Double.pi / 10, +Double.pi / 10, 0]
        
        rotate.keyTimes = [0, 0.1, 0.9, 1]
        rotate.duration = duration
        return rotate
    }
    
    private func xAnimation() -> CAKeyframeAnimation {
        let positionX = layer.position.x
        
        let xAnimation = CAKeyframeAnimation(keyPath: "position.x")
        xAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        xAnimation.values = [positionX, positionX - 5, positionX + 5, positionX]

        xAnimation.keyTimes = [0.0, 0.10, 0.50, 1.0]
        xAnimation.duration = duration
        return xAnimation
    }
    
    private func yAnimation() -> CAKeyframeAnimation {
        let positionY = layer.position.y
        
        let yAnimation = CAKeyframeAnimation(keyPath: "position.y")
        yAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        yAnimation.values = [positionY, positionY - 5, positionY + 5, positionY]
        
        yAnimation.keyTimes = [0.10, 0.25, 0.90, 1.0]
        yAnimation.duration = duration
        return yAnimation
    }
    
}
