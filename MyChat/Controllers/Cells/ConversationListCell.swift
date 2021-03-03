//
//  ConversationCellTableViewCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationListCell: UITableViewCell {
    static var reuseID: String = "ConversationListCell"
    
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let frameAvatarImageView = avatarImageView?.frame else { return }
        avatarImageView?.layer.cornerRadius = frameAvatarImageView.height / 2
        setCell()
    }
    
    func setCell() {
        if !online {
            backgroundColor = .white
        } else {
            let color = UIColor(displayP3Red: 1, green: 1, blue: 0.88, alpha: 1)
            backgroundColor = color
        }
        
        if messageLabel?.text == nil {
            messageLabel?.text = "No messages yet"
            messageLabel?.font = UIFont.italicSystemFont(ofSize: 17)
        } else {
            messageLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        
        if hasUnreadMessages {
            messageLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        nameLabel?.textColor = .black
    }

}
