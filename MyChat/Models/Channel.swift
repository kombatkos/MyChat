//
//  Channel.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.03.2021.
//

import Foundation
import FirebaseFirestore

struct Channel: Equatable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

extension Channel {
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let name = data["name"] as? String else { return nil }
        let identifier = document.documentID
        let lastMessage = data["lastMessage"] as? String
        let lastActivity = data["lastActivity"] as? Date
        
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
}
