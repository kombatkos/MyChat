//
//  ThemeButton.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 06.03.2021.
//

import UIKit

class ThemeButtonView: UIView {
    
    lazy var textLabel = UILabel()
    lazy var leftBubble = UIView()
    lazy var rightBubble = UIView()
    lazy var containerView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setClassicView()
    }
    
    override func draw(_ rect: CGRect) {
        let pathLeft = UIBezierPath(roundedRect: leftBubble.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.path = pathLeft.cgPath
        leftBubble.layer.mask = maskLayer
        
        let pathRight = UIBezierPath(roundedRect: rightBubble.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayerRight = CAShapeLayer()
        maskLayerRight.path = pathRight.cgPath
        rightBubble.layer.mask = maskLayerRight
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let figurePath = UIBezierPath(rect: containerView.frame)
        figurePath.append(UIBezierPath(rect: textLabel.frame))
                return figurePath.contains(point)
    }
    
    
    func setClassicView() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        rightBubble.translatesAutoresizingMaskIntoConstraints = false
        leftBubble.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        containerView.layer.borderWidth = 2

        containerView.addSubview(rightBubble)
        rightBubble.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        rightBubble.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        rightBubble.widthAnchor.constraint(equalToConstant: 117).isActive = true
        rightBubble.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        containerView.addSubview(leftBubble)
        leftBubble.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        leftBubble.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        leftBubble.widthAnchor.constraint(equalToConstant: 117).isActive = true
        leftBubble.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 25)
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
}
