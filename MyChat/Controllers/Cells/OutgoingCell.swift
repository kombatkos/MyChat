//
//  OutgoingCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 27.02.2021.
//

import UIKit

class OutgoingCell: IncomingCell {

    override func setContainerView() {
        textMessageLabel.numberOfLines = 0
        textMessageLabel.textColor = .white
        containerView.backgroundColor = .systemGreen
//            UIColor(red: 0.37, green: 0.62, blue: 0.63, alpha: 1.00)
        containerView.layer.cornerRadius = 15
    }
    
    override func setLeadingAndTrailingConstraintForContainerView() {
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: layer.bounds.width / 4).isActive = true
    }
}
