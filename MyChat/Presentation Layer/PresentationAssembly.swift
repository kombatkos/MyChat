//
//  PresentationAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import UIKit

protocol IPresentationAssembly {
    func assemblyPhotosCollectionVC() -> PhotosCollectionVC
    func assemblyProfileVC() -> ProfileViewController?
    func modelConversationList() -> ModelConversationList
    func fetchedResultControllerChannels() -> FetchedResultController
    func channelDataSource(frc: FetchedResultController?) -> TableViewDataSourceChannels
    func transitionManager() -> ITransitionManager
    func themeService() -> IThemeService
    func assemblyConversationVC(channelID: String) -> ConversationViewController
    func assemblyThemesVC() -> ThemesViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly()
    
    let appID = UIDevice.current.identifierForVendor?.uuidString
    
    // MARK: - ConversationListViewController
    
    func assemblyPhotosCollectionVC() -> PhotosCollectionVC {
        let palette = serviceAssembly.themeService.currentTheme()
        let model = ModelPhotosVC(imageService: serviceAssembly.imageService)
        guard let vc = PhotosCollectionVC(model: model, palette: palette) else {
            fatalError("failed to build PhotosCollectionVC") }
        let dataSource = PhotosCollectionDataSource(model: model, palette: palette, presentationController: vc)
        vc.collectionViewDataSource = dataSource
        return vc
    }
    
    // MARK: - ConversationListViewController
    
    func assemblyProfileVC() -> ProfileViewController? {
        let palette = serviceAssembly.themeService.currentTheme()
        
        guard let vc = UIStoryboard(name: "Profile",
                                    bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController else { return nil }
        vc.imagePicker = ImagePicker(presentationController: vc, delegate: vc, palette: palette, assembly: self)
        vc.palette = palette
        vc.profileService = serviceAssembly.saveProfileService
        return vc
    }
    
    // MARK: - ConversationListViewController
    
    func modelConversationList() -> ModelConversationList {
        return ModelConversationList(listenerService: serviceAssembly.listenerService,
                                     palette: serviceAssembly.themeService.currentTheme(),
                                     themeManager: serviceAssembly.themeService,
                                     saveProfileService: serviceAssembly.saveProfileService, fireStoreService: serviceAssembly.fireStoreService(channelID: ""))
    }
    
    func fetchedResultControllerChannels() -> FetchedResultController {
        return FetchedResultController(coreDataStack: serviceAssembly.coreDataStack)
    }
    
    func channelDataSource(frc: FetchedResultController?) -> TableViewDataSourceChannels {
        return TableViewDataSourceChannels(fetchedResultController: frc,
                                           palette: serviceAssembly.themeService.currentTheme())
    }
    
    func themeService() -> IThemeService {
        serviceAssembly.themeService
    }
    
    func transitionManager() -> ITransitionManager {
        TransitionManager()
    }
    
    // MARK: - assemblyConversationVC
    
    func assemblyConversationVC(channelID: String) -> ConversationViewController {
        let service = serviceAssembly.fireStoreService(channelID: channelID)
        let model = ModelConversation(channelID: channelID,
                                      listenerSerice: serviceAssembly.listenerService,
                                      firesoreService: service,
                                      profileService: serviceAssembly.saveProfileService)
        let frc = MessageFetchetResultController(coreDataStack: serviceAssembly.coreDataStack,
                                                 channelID: channelID)
        let dataSource = TableViewDataSourseConversation(fetchedResultController: frc,
                                                         palette: serviceAssembly.themeService.currentTheme(),
                                                         appID: appID ?? "")
        
        let vc = ConversationViewController(channelID: channelID,
                                            palette: serviceAssembly.themeService.currentTheme(),
                                            fetchedResultController: frc,
                                            listenerSerice: serviceAssembly.listenerService,
                                            tableViewDataSourse: dataSource,
                                            model: model)
        return vc
    }
    
    // MARK: - assemblyThemesVC
    func assemblyThemesVC() -> ThemesViewController {
        let vc = ThemesViewController(palette: serviceAssembly.themeService.currentTheme())
        return vc
    }
}
