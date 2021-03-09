//
//  ConversationCellTableViewCell.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationListCell: UITableViewCell {
    
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSubviews()
    }
    
    private func setSubviews() {
        
        messageLabel?.font = UIFont.systemFont(ofSize: 17)
        messageLabel?.textColor = ThemesManager.currentTheme().tableViewSubtitleColor
        dateLabel?.textColor = ThemesManager.currentTheme().tableViewSubtitleColor
        
        if messageLabel?.text == nil || messageLabel?.text == "No messages yet" {
            messageLabel?.text = "No messages yet"
            messageLabel?.font = UIFont.italicSystemFont(ofSize: 17)
        }
        
        if hasUnreadMessages {
            messageLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//            messageLabel?.textColor = .black
        }
//        nameLabel?.textColor = .black
    }

}
