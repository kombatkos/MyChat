//
//  ObjectExtensions.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import Foundation
import CoreData

extension ChannelCD {
    convenience init(name: String,
                     identifier: String,
                     lastMessage: String?,
                     lastActivity: Date?,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.identifier = identifier
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    var about: String {
        
        let description = "\(String(describing: name)) \n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageCD }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""
        
        return description + messages
    }
}

extension MessageCD {
    convenience init(content: String,
                     created: Date,
                     identifier: String,
                     senderID: String,
                     senderName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.identifier = identifier
        self.senderID = senderID
        self.senderName = senderName
    }
    
    var about: String {
        return "message: \(String(describing: content))"
    }
}
