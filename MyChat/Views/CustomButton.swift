//
//  CustomButton.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 01.03.2021.
//

import UIKit

class CustomButton: UIButton {

    override func layoutSubviews() {
        let avatar = AvatarView()
        addSubview(avatar)
    }

}
