//
//  Chat.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//
import Foundation

struct MyChat: ConversationCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
}
