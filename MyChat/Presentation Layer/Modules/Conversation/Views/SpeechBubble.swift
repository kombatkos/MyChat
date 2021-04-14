//
//  SpeechBubble.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 30.03.2021.
//

import UIKit

enum Side {
    case left, right
}

class SpeechBubble: UIView {
    
    var corners: UIRectCorner?
    
    convenience init(side: Side) {
        self.init()
        switch side {
        case .left:
            self.corners = [.bottomLeft, .bottomRight, .topRight]
        case .right:
            self.corners = [.bottomLeft, .bottomRight, .topLeft]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBezierForLeftBubble()
    }
    
    func setBezierForLeftBubble() {
        guard let corners = self.corners else { return }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
