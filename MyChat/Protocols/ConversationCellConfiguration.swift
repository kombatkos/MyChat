//
//  ConversationCellConfiguration.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//
import Foundation

protocol ConversationCellConfiguration {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
