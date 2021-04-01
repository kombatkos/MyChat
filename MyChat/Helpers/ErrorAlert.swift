//
//  ErrorAlert.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 25.03.2021.
//

import UIKit

class ErrorAlert {
    static func show(_ message: String, completion: (UIAlertController) -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        completion(alert)
    }
}
