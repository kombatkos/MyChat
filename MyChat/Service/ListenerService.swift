//
//  ListenerService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import UIKit
import FirebaseFirestore

class ListenerService {
    
    let appID = UIDevice.current.identifierForVendor?.uuidString
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var channelID = ""
    
    func channelObserve(completion: @escaping (Result<[Channel], Error>) -> Void) {
        let ref = reference
        ref.addSnapshotListener { [unowned self] (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let documents = querySnapshot?.documents {
                var channels: [Channel] = []
                for document in documents {
                    let data = document.data()
                    let identifire = document.documentID
                    if let name = data["name"] as? String {
                        let lastActivityTimestamp = document["lastActivity"] as? Timestamp
                        let lastActivity = lastActivityTimestamp?.dateValue()
                        let lastMessage = data["lastMessage"] as? String
                        let channel = Channel(identifier: identifire,
                                              name: self.nameHandler(text: name, isEmpty: "NoName"),
                                              lastMessage: lastMessage,
                                              lastActivity: lastActivity)
                        channels.append(channel)
                    }
                }
                
                completion(.success(channels))
            }
        }
    }
    
    func messagesObserve(channelID: String, completion: @escaping (Result<([Message], String), Error>) -> Void) {
        let ref = reference.document(channelID).collection("messages")
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let documents = querySnapshot?.documents {
                var messages: [Message] = []
                documents.forEach { document in
                    let data = document.data()
                    guard let content = data["content"] as? String,
                          let created = data["created"] as? Timestamp,
                          let senderId = data["senderId"] as? String,
                          let senderName = data["senderName"] as? String else { return }
                    
                    let message = Message(content: content, created: Date(timeIntervalSince1970: TimeInterval(created.seconds)), senderId: senderId, senderName: senderName)
                    let identifier = document.documentID
                    messages.append(message)
                    completion(.success((messages, identifier)))
                }
            }
        }
    }
    
    private func nameHandler(text: String?, isEmpty: String) -> String {
        let channelName = (text ?? isEmpty).trim()
        let name = channelName.isBlank ? isEmpty : channelName
        return name
    }
}
