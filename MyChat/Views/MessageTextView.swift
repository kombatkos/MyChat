//
//  MessageTextView.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 24.03.2021.
//

import UIKit

class MessageTextView: UITextView {
    
    let sendButton = UIButton()
    let palette: PaletteProtocol? = ThemesManager.currentTheme()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = palette?.bubbleLeftColor ?? .gray
        
        font = UIFont.systemFont(ofSize: 14)
        textColor = palette?.labelColor
        isScrollEnabled = false
        textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 35)
        keyboardAppearance = palette?.keyboardStyle ?? .light
        
        delegate = self
        textColor = .lightGray
        text = "Send message..."
        sendButton.isHidden = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        sendButton.tintColor = UIColor.darkGray
        addSubview(sendButton)
        
        let margins = self.layoutMarginsGuide
        sendButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
    }
}

// MARK: - UITextViewDelegate
extension MessageTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textColor = palette?.labelColor
            sendButton.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.text = "Send message..."
            textView.textColor = UIColor.lightGray
            sendButton.isHidden = true
        }
    }
}
