//
//  OutgoingCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 27.02.2021.
//

import UIKit

class OutgoingCell: IncomingCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.containerView = SpeechBubble(side: .right)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSubviews() {
        backgroundColor = .clear
        textMessageLabel.numberOfLines = 0
        textMessageLabel.textColor = palette?.rightBubbleLabelColor ?? .black
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = UIColor.gray
        containerView.backgroundColor = palette?.bubbleRightColor ?? .lightGray
//        backgroundColor = palette?.backgroundColor ?? .white
    }
    
    override func setLeadingAndTrailingConstraintForContainerView() {
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: layer.bounds.width / 4).isActive = true
    }
}
