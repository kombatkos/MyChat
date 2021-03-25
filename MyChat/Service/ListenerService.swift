//
//  ListenerService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import UIKit
import FirebaseFirestore

class ListenerService {
    
    let id = UIDevice.current.identifierForVendor?.uuidString
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var channelID = ""
    
    func channelObserve(completion: @escaping (Result<[Channel], Error>) -> Void) {
        let ref = reference
        ref.addSnapshotListener { (querySnapshot, error) in
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
                        channels.append(Channel(identifier: identifire,
                                                name: name,
                                                lastMessage: lastMessage,
                                                lastActivity: lastActivity))
                    }
                }
                completion(.success(channels))
            }
        }
    }
    
    func messagesObserve(channelID: String, completion: @escaping (Result<Message, Error>) -> Void) {
        let ref = reference.document(channelID).collection("messages")
        ref.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let content = diff.document.data()["content"] as? String,
                      let created = diff.document.data()["created"] as? Timestamp,
                      let senderId = diff.document.data()["senderId"] as? String,
                      let senderName = diff.document.data()["senderName"] as? String else { return }
                
                let message = Message(content: content, created: Date(timeIntervalSince1970: TimeInterval(created.seconds)), senderId: senderId, senderName: senderName)
                switch diff.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
    }
}
