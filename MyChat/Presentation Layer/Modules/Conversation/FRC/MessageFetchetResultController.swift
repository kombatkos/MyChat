//
//  MessageFetchetResultController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import CoreData

class MessageFetchetResultController: NSFetchedResultsController<MessageCD> {
    
    init(coreDataStack: IModernCoreDataStack, channelID: String) {
        
        let request: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "channel.identifier = %@", channelID)
        request.fetchBatchSize = 20
        
        let context = coreDataStack.container.viewContext
        context.automaticallyMergesChangesFromParent = true
    
        super.init()
        self.setValue(request, forKey: "fetchRequest")
        self.setValue(context, forKey: "managedObjectContext")
        self.setValue(nil, forKey: "sectionNameKeyPath")
        self.setValue(nil, forKey: "cacheName")
    }
}
