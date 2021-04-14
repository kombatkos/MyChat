//
//  CoreDataStack.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 31.03.2021.
//

import Foundation
import CoreData

class ModernCoreDataStack {
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

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// class CoreDataStack {
//
//    let queue = DispatchQueue.global(qos: .default)
//    var didUpdateDataBase: ((CoreDataStack) -> Void)?
//
//    private var storeUrl: URL = {
//        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
//                                                          in: .userDomainMask).last else {
//            fatalError("document path not found")
//        }
//        return documentsUrl.appendingPathComponent("MyChat.sqlite")
//    }()
//
//    private let dataModelName = "MyChat"
//    private let dataModelExtension = "momd"
//
//    // MARK: - init Stack
//
//    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
//        guard let modelURL = Bundle.main.url(forResource: self.dataModelName,
//                                             withExtension: self.dataModelExtension) else {
//            fatalError("model not found")
//        }
//
//        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("managedObjectModel cound not be created")
//        }
//
//        return managedObjectModel
//    }()
//
//    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//
//        do {
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
//                                               configurationName: nil,
//                                               at: self.storeUrl,
//                                               options: nil)
//            print(storeUrl)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//        return coordinator
//    }()
//
//    // MARK: - Contexts
//
//    private lazy var writterContext: NSManagedObjectContext = {
//        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        context.persistentStoreCoordinator = persistentStoreCoordinator
//        context.mergePolicy = NSOverwriteMergePolicy
//        return context
//    }()
//
//    private(set) lazy var mainContext: NSManagedObjectContext = {
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        context.parent = writterContext
//        context.automaticallyMergesChangesFromParent = true
//        context.mergePolicy = NSManagedObjectConstraintMergeError
//        return context
//    }()
//
//    private func saveContext() -> NSManagedObjectContext {
//        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        context.parent = mainContext
//        context.automaticallyMergesChangesFromParent = true
//        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        return context
//    }
//
//    // MARK: - Save Context
//
//    func performSave(_ block: (NSManagedObjectContext) -> Void) {
//        let context = saveContext()
//        context.performAndWait {
//            block(context)
//            if context.hasChanges {
//                performSave(in: context)
//            }
//        }
//    }
//
//    private func performSave(in context: NSManagedObjectContext) {
//        context.performAndWait {
//            do {
//                try context.save()
//            } catch {
//                assertionFailure(error.localizedDescription)
//            }
//        }
//        if let parent = context.parent { performSave(in: parent) }
//    }
//
//    // MARK: - CoreData Observers
//
//    func enableObservers() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self,
//                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
//                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
//                                       object: mainContext)
//    }
//
//    @objc
//    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else { return }
//
//        didUpdateDataBase?(self)
//
//        var shouldLogTextAnalyzer = false
//        if ProcessInfo.processInfo.environment["CoreData_save_log"] == "verbose" {
//            shouldLogTextAnalyzer = true
//        }
//
//        if shouldLogTextAnalyzer {
//            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
//               inserts.count > 0 {
//                print("Добавлено объектов: ", inserts.count)
//            }
//
//            if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
//               updates.count > 0 {
//                print("Обновлено объектов: ", updates.count)
//            }
//
//            if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
//               deletes.count > 0 {
//                print("Удалено объектов: ", deletes.count)
//            }
//        }
//    }
//
//    // MARK: - Core Data Logs
//
//    func printDatabaseStatistice() {
//        mainContext.perform {
//            var shouldLogTextAnalyzer = false
//            if ProcessInfo.processInfo.environment["CoreData_save_log"] == "verbose" {
//                shouldLogTextAnalyzer = true
//            }
//
//            if shouldLogTextAnalyzer {
//                do {
//                    let count = try self.mainContext.count(for: ChannelCD.fetchRequest())
//                    print("\(count) каналов")
//                    let array = try self.mainContext.fetch(ChannelCD.fetchRequest()) as? [ChannelCD] ?? []
//                    array.forEach { print($0.about) }
//                } catch {
//                    fatalError(error.localizedDescription)
//                }
//            }
//        }
//    }
// }
