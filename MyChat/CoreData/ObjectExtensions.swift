//
//  ObjectExtensions.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import Foundation
import CoreData
import FirebaseFirestore

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
    
    convenience init?(document: QueryDocumentSnapshot, in context: NSManagedObjectContext) {
        let data = document.data()
        guard let name = data["name"] as? String else { return nil }
        let identifier = document.documentID
        let lastMessage = data["lastMessage"] as? String
        let lastActivity = data["lastActivity"] as? Date
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
    
    convenience init?(document: QueryDocumentSnapshot, in context: NSManagedObjectContext) {
        let data = document.data()
        let content = data["content"] as? String
        let created = (data["created"]  as? Timestamp)?.dateValue()
        let senderID = data["senderId"] as? String
        let senderName = data["senderName"] as? String
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
    
    convenience init(content: String,
                     created: Date,
                     senderID: String,
                     senderName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
    
    var about: String {
        return "message: \(String(describing: content))"
    }
}
