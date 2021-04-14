//
//  FetchedResultController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import CoreData

class FetchedResultController: NSFetchedResultsController<ChannelCD> {
    
    let coreDataStack: ModernCoreDataStack
    
    init(coreDataStack: ModernCoreDataStack) {
        
        self.coreDataStack = coreDataStack
        let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
        
        let lastActivitySDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        let nameSDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [lastActivitySDescriptor, nameSDescriptor]
        
        let context = coreDataStack.container.viewContext
        context.automaticallyMergesChangesFromParent = true
    
        super.init()
        self.setValue(request, forKey: "fetchRequest")
        self.setValue(context, forKey: "managedObjectContext")
        self.setValue(nil, forKey: "sectionNameKeyPath")
        self.setValue(nil, forKey: "cacheName")
    }
}
