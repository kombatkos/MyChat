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
                        let correctName = !name.trim().isBlank ? name.trim() : "NoName"
                        let channel = Channel(identifier: identifire,
                                              name: correctName,
                                              lastMessage: lastMessage,
                                              lastActivity: lastActivity)
                        channels.append(channel)
                    }
                }
                
                completion(.success(channels))
            }
        }
    }
    
    func channelObserve2(channels: [Channel], completion: @escaping (Result<[Channel], Error>) -> Void) {
        var channels = channels
        let ref = reference
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                guard let channel = Channel(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !channels.contains(channel) else { return }
                    channels.append(channel)
                case .modified:
                    guard let index = channels.firstIndex(of: channel) else { return }
                    channels[index] = channel
                case .removed:
                    guard let index = channels.firstIndex(of: channel) else { return }
                    channels.remove(at: index)
                }
            }
            completion(.success(channels))
        }
    }
    
    func messagesObserve2(messages: [Message], channelID: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        var messages = messages
        let ref = reference.document(channelID).collection("messages")
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                guard let message = Message(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    guard !messages.contains(message) else { return }
                    messages.append(message)
                case .modified:
                    guard let index = messages.firstIndex(of: message) else { return }
                    messages[index] = message
                case .removed:
                    guard let index = messages.firstIndex(of: message) else { return }
                    messages.remove(at: index)
                }
            }
            completion(.success(messages))
        }
    }
    
    func messagesObserve(channelID: String, completion: @escaping (Result<[Message], Error>) -> Void) {
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
                          let created = (data["created"] as? Timestamp)?.dateValue(),
                          let senderId = data["senderId"] as? String,
                          let senderName = data["senderName"] as? String else { return }
                    
                    let message = Message(content: content, created: created, senderId: senderId, senderName: senderName)
                    messages.append(message)
                }
                completion(.success(messages))
            }
        }
    }
    
}
