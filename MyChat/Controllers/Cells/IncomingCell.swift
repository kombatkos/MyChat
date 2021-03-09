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
    
    weak var delegate: ThemesPickerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setBezierForContainerView()
    }
    
    private func setCell() {
        setSubviews()
        contentView.addSubview(containerView)
        containerView.addSubview(textMessageLabel)
        setConstraints()
    }
    
    @objc func setBezierForContainerView() {
        let path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    @objc func setSubviews() {
        textMessageLabel.numberOfLines = 0
        containerView.backgroundColor = ThemesManager.currentTheme().bubbleLeftColor
        backgroundColor = ThemesManager.currentTheme().backgroundColor
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
