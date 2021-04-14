//
//  ModelConversationList.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import UIKit

protocol IModelConversationList {
    var palette: PaletteProtocol? {get}
    func changeTheme(completion: @escaping (_ palette: PaletteProtocol?) -> Void)
    func addChannel(completion: (UIAlertController) -> Void)
    func observeChannel(completion: @escaping (_ error: Error) -> Void)
}

class ModelConversationList: IModelConversationList {
    
    var palette: PaletteProtocol?
    let fireStoreService = FirestoreService(channelID: "")
    private let coreDataStack: ModernCoreDataStack
    private var listenerService: ListenerService?
    
    init(coreDataStack: ModernCoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func observeChannel(completion: @escaping (_ error: Error) -> Void) {
        listenerService = ListenerService(coreDataStack: coreDataStack)
        listenerService?.channelObserve { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    // MARK: - Add new Channel
    
    func addChannel(completion: (UIAlertController) -> Void) {
        let fireStoreService = FirestoreService(channelID: "")
        
        let alert = UIAlertController(title: "Add shannel", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.backgroundColor = .white
            alert.textFields?.first?.textColor = .black
            textField.placeholder = "New channel..."
        }
        let addChannel = UIAlertAction(title: "Add", style: .default) { _ in
            let text = alert.textFields?.first?.text
            fireStoreService.addNewChannel(text: text)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(addChannel)
        completion(alert)
    }
    
    // MARK: - Сhange Theme
    
    func changeTheme(completion: @escaping (_ palette: PaletteProtocol?) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.palette = ThemesService.currentTheme()
            
            completion(self?.palette)
//            self?.view.backgroundColor = self?.palette?.backgroundColor ?? .white
            
            UIActivityIndicatorView.appearance().style = self?.palette?.activityIndicatorStyle ?? .gray
            UITextField.appearance().keyboardAppearance = self?.palette?.keyboardStyle ?? .light
            UITextView.appearance().textColor = self?.palette?.labelColor
            UITextField.appearance().backgroundColor = self?.palette?.tableViewHeaderFooterColor
            UITextField.appearance().textColor = self?.palette?.labelColor
            UILabel.appearance().textColor = self?.palette?.labelColor
            UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = self?.palette?.tableViewHeaderFooterColor
            UITableViewCell.appearance().backgroundColor = self?.palette?.backgroundColor
            UITableViewCell.appearance().selectedBackgroundView = self?.palette?.cellSelectedView
            UITableView.appearance().backgroundColor = self?.palette?.backgroundColor
            UINavigationBar.appearance().barStyle = self?.palette?.barStyle ?? .default
            
            UIApplication.shared.keyWindow?.reload()
            UIApplication.shared.keyWindow?.reload()
        }
    }
}
