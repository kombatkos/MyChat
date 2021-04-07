//
//  ConversationCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class IncomingCell: UITableViewCell {
    
    var containerView: SpeechBubble
    let textMessageLabel = UILabel()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    
    var palette: PaletteProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        containerView = SpeechBubble(side: .left)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCell()
    }
    
    @objc func setCell() {
        setSubviews()
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(textMessageLabel)
        containerView.addSubview(dateLabel)
        setConstraints()
    }
    
    @objc func setSubviews() {
        textMessageLabel.numberOfLines = 0
        nameLabel.font = .preferredFont(forTextStyle: .callout)
        let nameLabelColor = UIColor(red: 48 / 255, green: 136 / 255, blue: 251 / 255, alpha: 1)
        nameLabel.textColor = nameLabelColor
        dateLabel.font = .preferredFont(forTextStyle: .caption2)
        dateLabel.textColor = UIColor.gray
        containerView.backgroundColor = palette?.bubbleLeftColor ?? .darkGray
        backgroundColor = palette?.backgroundColor ?? .white
    }
    
}

// MARK: - Setup Constraints

extension IncomingCell {
    
    @objc func setConstraints() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        
        textMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        textMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        textMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        textMessageLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -3).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -3).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        dateLabel.textAlignment = .right
        
        setLeadingAndTrailingConstraintForContainerView()
    }
    
    @objc func setLeadingAndTrailingConstraintForContainerView() {
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -(layer.bounds.width / 4)).isActive = true
    }
    
}
