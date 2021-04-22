//
//  MessageBar2.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 24.03.2021.
//

import UIKit

class MessageBar: UIView {
    
    var palette: PaletteProtocol?
    var messageTextView: MessageTextView?
    var plusButton = UIButton()
    
    convenience init(palette: PaletteProtocol?) {
        self.init()
        self.palette = palette
        setupConstraints()
        messageTextView = MessageTextView(palette: palette)
        backgroundColor = palette?.conversationBottomViewColor ?? .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        messageTextView?.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(plusButton)
        setupUIElements()
        plusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(messageTextView ?? UITextView())
        messageTextView?.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 14).isActive = true
        messageTextView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        messageTextView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        messageTextView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
    }
    
    private func setupUIElements() {
        plusButton.setImage(#imageLiteral(resourceName: "Shape"), for: .normal)
    }
}
