//
//  ProfileButton.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.04.2021.
//

import UIKit

class ProfileButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layer.cornerRadius = 17.5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        self.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        getInitiales { [weak self] initiales in
            if let initiales = initiales, initiales != "" {
                self?.setTitle(initiales, for: UIControl.State.normal)
                self?.titleLabel?.font = .systemFont(ofSize: 14)
                self?.setTitleColor(.black, for: .normal)
                self?.setTitleColor(.white, for: .highlighted)
            } else {
                self?.setImage(#imageLiteral(resourceName: "avatarSmall"), for: .normal)
                self?.clipsToBounds = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getInitiales(completion: @escaping (String?) -> Void) {
        SaveProfileService(fileManager: FilesManager()).loadProfile { (profile) in
            var initiales = ""
            if let fullNameArr = profile?.name?.split(separator: " ") {
                if fullNameArr.count > 0 {
                    guard let firstWord = fullNameArr[0].first else { return }
                    initiales += String(firstWord)
                }
                if fullNameArr.count > 1 {
                    guard let firstWord = fullNameArr[1].first else { return }
                    initiales += String(firstWord)
                }
            }
            completion(initiales)
        }
    }
}
