//
//  FirestoreService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    var channelID: String
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    init(channelID: String) {
        self.channelID = channelID
    }
    
    func sendMessage(message: Message) {
        let messagesRef = reference.document(channelID).collection("messages")
        let dictionary: [String: Any] = ["senderName": message.senderName,
                                         "content": message.content,
                                         "created": Timestamp(date: message.created),
                                         "senderId": message.senderId]
        messagesRef.addDocument(data: dictionary)
    }
    
    func addNewChannel(text: String?) {
        guard let text = text?.trim() else { return }
        if !text.isBlank {
            self.reference.addDocument(data: ["name": text])
        }
    }
    
    func deleteChannel() {
        reference.document(channelID).delete()
    }
}
