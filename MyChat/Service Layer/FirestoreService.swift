//
//  FirestoreService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import FirebaseFirestore

protocol IFirestoreService {
    var channelID: String {get set}
    func sendMessage(message: Message)
    func addNewChannel(text: String?)
    func deleteChannel()
}

class FirestoreService: IFirestoreService {
    
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
