//
//  CustomTextField.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 11.03.2021.
//

import UIKit

class MessageTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let palette: PaletteProtocol? = ThemesManager.currentTheme()
        backgroundColor = palette?.bubbleLeftColor ?? .gray
        attributedPlaceholder = NSAttributedString(string: "Your message here …",
                                                   attributes: [NSAttributedString.Key.foregroundColor: palette?.placeHolderColor ?? .lightGray])
        font = UIFont.systemFont(ofSize: 14)
        textColor = palette?.labelColor
        clearButtonMode = .whileEditing
        borderStyle = .none

        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Sent"), for: .normal)

        rightView = button
        rightView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightViewMode = .whileEditing
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.layer.frame.height / 2
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 36, dy: 0)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x += -12
        return rect
    }
}
