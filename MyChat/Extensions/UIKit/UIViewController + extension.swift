//
//  UIViewController + extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.03.2021.
//

import UIKit

extension UIViewController {
    
    // MARK: - Kyeboard methods
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notofication: Notification) {
        let userInfo = notofication.userInfo
        guard let kewboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = -kewboardFrameSize.height
    }
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
}
