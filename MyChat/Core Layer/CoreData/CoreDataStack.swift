//
//  CoreDataStack.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import Foundation
import CoreData

protocol IModernCoreDataStack {
    var container: NSPersistentContainer {get}
}

class ModernCoreDataStack: IModernCoreDataStack {
    private let dataBaseName = "MyChat"

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
}
