//
//  OutgoingCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 27.02.2021.
//

import UIKit

class OutgoingCell: IncomingCell {
    
    override func setBezierForContainerView() {
        let path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }

    override func setSubviews() {
        textMessageLabel.numberOfLines = 0
        textMessageLabel.textColor = ThemesManager.currentTheme().rightBubbleLabelColor
        containerView.backgroundColor = ThemesManager.currentTheme().bubbleRightColor
        backgroundColor = ThemesManager.currentTheme().backgroundColor
    }
    
    override func setLeadingAndTrailingConstraintForContainerView() {
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: layer.bounds.width / 4).isActive = true
    }
}
