//
//  MessageBar2.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 24.03.2021.
//

import UIKit

class MessageBar: UIView {
    
    var messageTextField = MessageTextView()
    var plusButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
}

// MARK: - Setup Constraints
extension MessageBar {
    private func setupConstraints() {
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(plusButton)
        setupUIElements()
        plusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(messageTextField)
        messageTextField.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 14).isActive = true
        messageTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        messageTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupUIElements() {
        plusButton.setImage(#imageLiteral(resourceName: "Shape"), for: .normal)
    }
}
