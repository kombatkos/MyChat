//
//  PresentationAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import UIKit

class PresentationAssembly {
    
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly()
    
    let appID = UIDevice.current.identifierForVendor?.uuidString
    
    // MARK: - ConversationListViewController
    
    func assemblyProfileVC() -> ProfileViewController? {
        let palette = serviceAssembly.themeService.currentTheme()
        
        guard let vc = UIStoryboard(name: "Profile",
                                    bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController else { return nil }
        vc.imagePicker = ImagePicker(presentationController: vc, delegate: vc, palette: palette)
        vc.palette = palette
        vc.profileService = serviceAssembly.saveProfileService
        return vc
    }
    
    // MARK: - ConversationListViewController
    
    func modelConversationList() -> ModelConversationList {
        return ModelConversationList(listenerService: serviceAssembly.listenerService,
                                     palette: serviceAssembly.themeService.currentTheme(),
                                     themeManager: serviceAssembly.themeService,
                                     saveProfileService: serviceAssembly.saveProfileService)
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
