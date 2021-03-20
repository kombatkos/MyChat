//
//  AvatarView.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 23.02.2021.
//

import UIKit

class AvatarView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let avatarViewWidth = self.frame.width
        self.layer.cornerRadius = avatarViewWidth / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let circlePath = UIBezierPath(ovalIn: self.bounds)
                return circlePath.contains(point)
        
    }
}
