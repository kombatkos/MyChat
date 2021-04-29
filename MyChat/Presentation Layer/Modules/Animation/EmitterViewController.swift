//
//  EmitterViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 28.04.2021.
//

import UIKit

class EmitterViewController: UIViewController {
    
    let emitter = CAEmitterLayer()
    var pointTap: CGPoint?
    var alphaParticles: CGFloat = 1
    let lifeTimeEmitter: Float = 3
    private var animating = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
    }
}

extension EmitterViewController {
    
    func setGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .began:
            animating = true
            pointTap = gesture.location(in: view)
            createParticles()
        case .changed:
            animating = true
            pointTap = gesture.location(in: view)
            createParticles()
        default:
            animating = false
            stopAnimation()
        }
    }
    
    func createParticles() {
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        emitter.frame = rect
        emitter.emitterSize = rect.size
        view.layer.addSublayer(emitter)
        
        guard let pointTap = self.pointTap else { return }
        emitter.emitterShape = CAEmitterLayerEmitterShape.sphere
        emitter.emitterPosition = pointTap
        
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = lifeTimeEmitter
        cell.velocity = 10
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.spinRange = 5
        cell.scale = 0.5
        cell.scaleRange = 0.25
        cell.color = UIColor(white: 1, alpha: alphaParticles).cgColor
        cell.alphaSpeed = -0.3
        cell.contents = UIImage(named: "gerb")?.cgImage
        emitter.emitterCells = [cell]
    }
    
    func stopAnimation() {
        self.alphaParticles = 0
        self.createParticles()
        self.alphaParticles = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if !self.animating {
                self.emitter.removeFromSuperlayer()
                self.emitter.layoutIfNeeded()
            }
        }
    }
}
