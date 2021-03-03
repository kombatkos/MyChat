//
//  ConversationCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class IncomingCell: UITableViewCell {
    
    let containerView = UIView()
    let textMessageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        setContainerView()
        contentView.addSubview(containerView)
        containerView.addSubview(textMessageLabel)
        setConstraints()
    }
    
    @objc func setContainerView() {
        textMessageLabel.numberOfLines = 0
        containerView.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
        containerView.layer.cornerRadius = 15
    }
    
}

// MARK: - Setup Constraints

extension IncomingCell {
    
    @objc func setConstraints() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        textMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        textMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        textMessageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        textMessageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        
        setLeadingAndTrailingConstraintForContainerView()
        
    }
    
    @objc func setLeadingAndTrailingConstraintForContainerView() {
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -(layer.bounds.width / 4)).isActive = true
    }
    
}
