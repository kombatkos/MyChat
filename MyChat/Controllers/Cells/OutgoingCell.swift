//
//  OutgoingCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 27.02.2021.
//

import UIKit

class OutgoingCell: IncomingCell {

    override func setSubviews() {
        textMessageLabel.numberOfLines = 0
        textMessageLabel.textColor = .white
        containerView.backgroundColor = .systemGreen
        containerView.layer.cornerRadius = 15
    }
    
    override func setLeadingAndTrailingConstraintForContainerView() {
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: layer.bounds.width / 4).isActive = true
    }
}
