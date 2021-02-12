//
//  AppDelegate.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.02.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var state: String = "Not running"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let function = #function
        printLog(state: "Inactive", function: function)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let function = #function
        printLog(state: "Inactive", function: function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let function = #function
        printLog(state: "Background", function: function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let function = #function
        printLog(state: "Inactive", function: function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let function = #function
        printLog(state: "Active", function: function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let function = #function
        printLog(state: "Suspended", function: function)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
// MARK: - Set Log
extension AppDelegate {
    
    var logON: Bool {
        return true
    }
    
    private func printLog(state: String, function: String) {
        if logON {
            print("App: Application moved from \(self.state) to \(state): \n     \(function) \n")
            self.state = state
        }
    }
}
