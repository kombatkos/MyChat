//
//  ModelConversationList.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import UIKit

protocol IModelConversationList {
    var palette: PaletteProtocol? {get}
    var saveProfileService: ISaveProfileService? {get}
    func changeTheme(completion: @escaping (_ palette: PaletteProtocol?) -> Void)
    func addChannel(completion: (UIAlertController) -> Void)
    func observeChannel(completion: @escaping (_ error: Error) -> Void)
}

class ModelConversationList: IModelConversationList {
    
    var palette: PaletteProtocol?
    private var listenerService: IListenerService?
    private var themeManager: IThemeService?
    var saveProfileService: ISaveProfileService?
    
    init(listenerService: IListenerService, palette: PaletteProtocol?, themeManager: IThemeService, saveProfileService: ISaveProfileService?) {
        self.themeManager = themeManager
        self.listenerService = listenerService
        self.palette = palette
        self.saveProfileService = saveProfileService
    }
    
    func observeChannel(completion: @escaping (_ error: Error) -> Void) {
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
            
            self?.palette = self?.themeManager?.currentTheme()
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
            
            completion(self?.palette)
        }
    }
}
