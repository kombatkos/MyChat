//
//  Channel.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.03.2021.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
