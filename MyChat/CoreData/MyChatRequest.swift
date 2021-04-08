//
//  MyChatRequest.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import Foundation
import CoreData

struct MyChatRequest {
    let coreDataStack: ModernCoreDataStack
    
    init(coreDataStack: ModernCoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func insertChannelRequest(channel: Channel) {
        let context = coreDataStack.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.performAndWait {
            let newChannel = ChannelCD(name: channel.name,
                                       identifier: channel.identifier,
                                       lastMessage: channel.lastMessage,
                                       lastActivity: channel.lastActivity,
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
    
    func modifiedChanelRequest(channel: Channel) {
        let context = coreDataStack.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
    
    func removeChannelRequest(channel: Channel) {
        let context = coreDataStack.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.performAndWait {
            guard let object = fetchRequestWithPredicateUser(by: "identifier", with: channel.identifier, context: context)?.first else { return }
            object.managedObjectContext?.delete(object)
            
            do { try context.save() } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRequestWithPredicateUser(by field: String, with value: String, context: NSManagedObjectContext) -> [NSManagedObject]? {
        let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
        
        request.predicate = NSPredicate(format: "\(field) == %@", value)
        
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            return nil
        }
    }
    
    func fetchChannels() -> [Channel] {
        let context = coreDataStack.container.viewContext
        let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
        var channels: [Channel] = []
        do {
            let result = try context.fetch(request)
            result.forEach { channel in
                guard let name = channel.name,
                      let id = channel.identifier else { return }
                let channel = Channel(identifier: name, name: id, lastMessage: channel.lastMessage, lastActivity: channel.lastActivity)
                channels.append(channel)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
        return channels
    }
    
}
