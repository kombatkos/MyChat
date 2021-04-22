//
//  Spiner.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.04.2021.
//

import UIKit

class Spinner: UIActivityIndicatorView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func configure() {
        transform = CGAffineTransform(scaleX: 3, y: 3)
        color = .red
    }
}
