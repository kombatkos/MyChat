//
//  Message.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.03.2021.
//

import Foundation
import FirebaseFirestore

struct Message: Equatable {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

extension Message {
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let content = data["content"] as? String,
              let created = (data["created"] as? Timestamp)?.dateValue(),
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String else { return nil }
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}
