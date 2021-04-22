//
//  AppDelegate.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.02.2021.
//

import UIKit
import CoreData
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
//        let controller = PresentationAssembly().assemblyPhotosCollectionVC()
//        window?.rootViewController = controller
//        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}
