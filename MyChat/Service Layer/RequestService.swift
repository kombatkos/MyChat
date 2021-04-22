//
//  MyChatRequest.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import CoreData

protocol IRequestService {
    func insertChannelRequest(channel: [Channel])
    func modifiedChanelRequest(channel: Channel)
    func removeChannelRequest(channel: Channel)
    func saveNewMessage(channelID: String, messages: [Message])
}

struct RequestService: IRequestService {
    
    let coreDataStack: IModernCoreDataStack
    let context: NSManagedObjectContext
    
    init(coreDataStack: IModernCoreDataStack) {
        self.coreDataStack = coreDataStack
        context = coreDataStack.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func insertChannelRequest(channel: [Channel]) {
        DispatchQueue.global(qos: .utility).async {
            
            context.performAndWait {
                channel.forEach {
                    guard getObjectRequest(entityName: "ChannelCD",
                                           predicate: "identifier",
                                           $0.identifier as CVarArg,
                                           context: coreDataStack.container.viewContext) == nil else { return }
                    
                    let newChannel = ChannelCD(name: $0.name,
                                               identifier: $0.identifier,
                                               lastMessage: $0.lastMessage,
                                               lastActivity: $0.lastActivity,
                                               in: context)
                    
                    let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
                    request.fetchLimit = 1
                    
                    do {
                        var result = try context.fetch(request)
                        result.append(newChannel)
                        try context.save()
                    } catch let error { print(error.localizedDescription) }
                }
            }
        }
    }
    
    func modifiedChanelRequest(channel: Channel) {
        DispatchQueue.global(qos: .utility).async {
            
            context.performAndWait {
                let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
                request.predicate = NSPredicate(format: "identifier == %@", channel.identifier)
                
                do {
                    let result = try context.fetch(request)
                    result.first?.lastMessage = channel.lastMessage
                    result.first?.lastActivity = channel.lastActivity
                    try context.save()
                } catch let error { print(error.localizedDescription) }
            }
        }
    }
    
    func removeChannelRequest(channel: Channel) {
        DispatchQueue.global(qos: .utility).async {
            
            context.performAndWait {
                guard let object = getObjectRequest(entityName: "ChannelCD",
                                                    predicate: "identifier",
                                                    channel.identifier as CVarArg,
                                                    context: context) else { return }
                object.managedObjectContext?.delete(object)
                
                do { try context.save() } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveNewMessage(channelID: String, messages: [Message]) {
        DispatchQueue.global(qos: .utility).async {
            
            let context = self.coreDataStack.container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
            request.predicate = NSPredicate(format: "identifier = %@", channelID)
            
            context.performAndWait {
                guard let channel = (try? context.fetch(request))?.last else { return }
                
                messages.forEach {
                    guard getObjectRequest(entityName: "MessageCD",
                                           predicate: "created",
                                           $0.created as CVarArg,
                                           context: coreDataStack.container.viewContext) == nil else { return }
                    
                    let message = MessageCD(content: $0.content,
                                            created: $0.created,
                                            senderID: $0.senderId,
                                            senderName: $0.senderName,
                                            in: context)
                    channel.addToMessages(message)
                    
                }
                if context.hasChanges {
                    do { try context.save() } catch let error {
                        assertionFailure(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getObjectRequest<T>(entityName: String, predicate format: String, _ value: CVarArg, context: NSManagedObjectContext) -> T? where T: NSManagedObject {
        
        let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "\(format) = %@", value)
        
        var object: NSManagedObject?
        
        context.performAndWait {
            do {
                let searchMessage = try context.fetch(request)
                object = searchMessage.first
            } catch let error { assertionFailure(error.localizedDescription) }
        }
        return object as? T
    }
    
}
