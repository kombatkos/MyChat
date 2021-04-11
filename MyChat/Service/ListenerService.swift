//
//  ListenerService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import UIKit
import FirebaseFirestore

class ListenerService {
    
    let coreDataStack: ModernCoreDataStack
    
    let appID = UIDevice.current.identifierForVendor?.uuidString
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var requests = MyChatRequest(coreDataStack: coreDataStack)
    
    init(coreDataStack: ModernCoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func channelObserve(completion: @escaping (Error?) -> Void) {
        
        let ref = reference
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }
            var channels: [Channel] = []
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                
                guard let channel = Channel(document: diff.document) else { return }
                
                switch diff.type {
                case .added:
                    channels.append(channel)
                case .modified:
                    print("----------------- MODIFIED ------------------")
                    self.requests.modifiedChanelRequest(channel: channel)
                case .removed:
                    print("----------------- REMOVED ------------------")
                    self.requests.removeChannelRequest(channel: channel)
                }
            }
            self.requests.insertChannelRequest2(channel: channels)
        }
    }
    
    func messagesObserve2(channelID: String, completion: @escaping (Error?) -> Void) -> ListenerRegistration {
        
        let ref = reference.document(channelID).collection("messages")
        let messagesListener = ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }
            var messages: [Message] = []
                guard let snapshot = querySnapshot else { return }
                snapshot.documentChanges.forEach { diff in
                    
                    guard let message = Message(document: diff.document) else { return }
                    switch diff.type {
                    case .added:
                        messages.append(message)
                    default: break
                    }
                }
            self.requests.saveNewMessage(channelID: channelID, messages: messages)
        }
        return messagesListener
    }
    
}
