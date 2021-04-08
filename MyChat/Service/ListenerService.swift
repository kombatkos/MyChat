//
//  ListenerService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import UIKit
import FirebaseFirestore
import CoreData

class ListenerService {
    
    let coreDataStack: ModernCoreDataStack
    
    let appID = UIDevice.current.identifierForVendor?.uuidString
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    lazy var request = MyChatRequest(coreDataStack: coreDataStack)
    
    init(coreDataStack: ModernCoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func channelObserve(completion: @escaping (Error?) -> Void) {
        
        var channels = request.fetchChannels()
        let ref = reference
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { diff in
                
                guard let channel = Channel(document: diff.document) else { return }
                
                switch diff.type {
                case .added:
                    // print("----------------- ADDED ------------------")
                    guard !channels.contains(channel) else { return }
                    channels.append(channel)
                    self.request.insertChannelRequest(channel: channel)
                case .modified:
                    print("----------------- MODIFIED ------------------")
                    self.request.modifiedChanelRequest(channel: channel)
                case .removed:
                    print("----------------- REMOVED ------------------")
                    self.request.removeChannelRequest(channel: channel)
                    guard channels.contains(channel) else { return }
                }
            }
        }
    }
    
    func messagesObserve(channelID: String, completion: @escaping (Error?) -> Void) {
        
        let ref = reference.document(channelID).collection("messages")
        ref.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(error)
            }
            let context = self.coreDataStack.container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
            request.predicate = NSPredicate(format: "identifier = %@", channelID)
            
            context.performAndWait {
                
                guard let channel = (try? context.fetch(request))?.last else { return }
                var newMessage = [MessageCD]()
                
                guard let snapshot = querySnapshot else { return }
                snapshot.documentChanges.forEach { diff in
                    
                    guard let message = MessageCD(document: diff.document, in: context) else { return }
                    switch diff.type {
                    case .added:
                        newMessage.append(message)
                    case .modified:
                        break
                    case .removed:
                        break
                    }
                }
                
                newMessage.forEach { channel.addToMessages($0) }
                if context.hasChanges {
                    do { try context.save() } catch let error {
                        assertionFailure(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
