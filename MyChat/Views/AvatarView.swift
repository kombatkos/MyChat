//
//  AvatarView.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 23.02.2021.
//

import UIKit

class AvatarView: UIView {

    override func layoutSubviews() {
        let avatarViewWidth = self.frame.width
        self.layer.cornerRadius = avatarViewWidth / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
        initialesLabels()
    }
    
    func initialesLabels() {
        let stackView = UIStackView()
        let firstWordOfName = UILabel(text: "M")
        let firstWordOfLastName = UILabel(text: "D")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let avatarViewWidth = self.frame.width
        firstWordOfName.font = UIFont.systemFont(ofSize: avatarViewWidth / 2)
        firstWordOfLastName.font = UIFont.systemFont(ofSize: avatarViewWidth / 2)
        
        firstWordOfName.textAlignment = .right
        firstWordOfLastName.textAlignment = .left
        
        stackView.addArrangedSubview(firstWordOfName)
        stackView.addArrangedSubview(firstWordOfLastName)
        self.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.axis = .horizontal
        stackView.spacing = -10
        stackView.contentMode = .scaleAspectFit
    }

    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let circlePath = UIBezierPath(ovalIn: self.bounds)
                return circlePath.contains(point)
        
    }
}
