//
//  MyChatRequest.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import Foundation
import CoreData

struct MyChatRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func saveMessageRequest(channelID: String, messages: [Message]) {
        let queue = DispatchQueue.global(qos: .default)
        getChannelRequest(context: coreDataStack.mainContext, channelID: channelID) { channel in
            
            queue.async {
                coreDataStack.performSave { context in
                    let channel = ChannelCD(name: channel.name ?? "",
                                            identifier: channel.identifier ?? "",
                                            lastMessage: channel.lastMessage,
                                            lastActivity: channel.lastActivity, in: context)
                    messages.forEach { message in
                        let message = MessageCD(content: message.content,
                                                created: message.created,
                                                senderID: message.senderId,
                                                senderName: message.senderName, in: context)
                        channel.addToMessages(message)
                    }
                }
            }
            
        }
    }
    
    func saveChannelRequest(channels: [Channel]) {
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            coreDataStack.performSave { context in
                channels.forEach { (channel) in
                    _ = ChannelCD(name: channel.name,
                                  identifier: channel.identifier,
                                  lastMessage: channel.lastMessage,
                                  lastActivity: channel.lastActivity, in: context)
                }
            }
        }
    }
    
    func getChannelRequest(context: NSManagedObjectContext, channelID: String, completion: @escaping (_ chanel: ChannelCD) -> Void) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "ChannelCD", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        do {
            guard let objects = try context.fetch(request) as? [ChannelCD] else { return }
            objects.forEach {
                if $0.identifier == channelID { completion($0) }
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
}
