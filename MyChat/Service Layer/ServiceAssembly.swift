//
//  ServiceAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

protocol IServicesAssembly {
    var requestService: IRequestService {get}
    var saveProfileService: ISaveProfileService {get}
    var listenerService: IListenerService {get}
    var themeService: IThemeService {get}
    var coreDataStack: IModernCoreDataStack {get}
    func fireStoreService(channelID: String) -> IFirestoreService
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly = CoreAssembly()
    
    lazy var coreDataStack: IModernCoreDataStack = coreAssembly.coreDataStack
    lazy var themeService: IThemeService = ThemeService(fileNames: coreAssembly.fileNames, filesManager: coreAssembly.filesManager)
    lazy var requestService: IRequestService = RequestService(coreDataStack: coreAssembly.coreDataStack)
    lazy var saveProfileService: ISaveProfileService = SaveProfileService(fileManager: coreAssembly.filesManager, fileNames: coreAssembly.fileNames)
    lazy var listenerService: IListenerService = ListenerService(coreDataStack: coreAssembly.coreDataStack)
    func fireStoreService(channelID: String) -> IFirestoreService {
        FirestoreService(channelID: channelID)
    }
    
}
