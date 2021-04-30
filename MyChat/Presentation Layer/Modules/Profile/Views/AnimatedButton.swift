//
//  AnimatedButton.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 28.04.2021.
//

import UIKit

class AnimatedButton: UIButton {
    
    var isAnimated = false
    private let duration = 0.3
    
    func jiggle() {
        if !isAnimated { startAnimation() } else { stopAnimation() }
    }
    
    func startAnimation() {
        isAnimated = true
        let group = CAAnimationGroup()
        group.duration = duration
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.animations = [yAnimation(), xAnimation(), rotateAnimation()]
        group.repeatCount = .infinity
        self.layer.add(group, forKey: nil)
    }
    
    func stopAnimation() {
        isAnimated = false
        layer.removeAllAnimations()
        
        let rotationReturn = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        rotationReturn.fromValue = layer.presentation()?.transform
        rotationReturn.toValue = layer.transform
        
        let returnAnimation = CABasicAnimation(keyPath: "position")
        returnAnimation.fromValue = layer.presentation()?.position
        returnAnimation.toValue = layer.position
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .both
        group.isRemovedOnCompletion = true
        group.animations = [rotationReturn, returnAnimation]
        layer.add(group, forKey: "position")
        
    }
    
    private func rotateAnimation() -> CAKeyframeAnimation {
        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotate.values = [0, -Double.pi / 10, +Double.pi / 10, 0]
        rotate.keyTimes = [0, 0.1, 0.9, 1]
        return rotate
    }
    
    private func xAnimation() -> CAKeyframeAnimation {
        let positionX = layer.position.x
        
        let xAnimation = CAKeyframeAnimation(keyPath: "position.x")
        xAnimation.values = [positionX, positionX - 5, positionX + 5, positionX]
        xAnimation.keyTimes = [0.0, 0.10, 0.50, 1.0]
        return xAnimation
    }
    
    private func yAnimation() -> CAKeyframeAnimation {
        let positionY = layer.position.y
        
        let yAnimation = CAKeyframeAnimation(keyPath: "position.y")
        yAnimation.values = [positionY, positionY - 5, positionY + 5, positionY]
        yAnimation.keyTimes = [0.10, 0.25, 0.90, 1.0]
        return yAnimation
    }
    
}
