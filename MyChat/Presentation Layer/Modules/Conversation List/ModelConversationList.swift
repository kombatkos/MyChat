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
    func addChannel(completion: (UIAlertController) -> Void, scoup: @escaping (Bool) -> Void )
    func observeChannel(completion: @escaping (_ error: Error) -> Void)
}

class ModelConversationList: IModelConversationList {
    
    var palette: PaletteProtocol?
    private let listenerService: IListenerService?
    private let themeManager: IThemeService?
    private let fireStoreService: IFirestoreService?
    let saveProfileService: ISaveProfileService?
    
    init(listenerService: IListenerService,
         palette: PaletteProtocol?,
         themeManager: IThemeService,
         saveProfileService: ISaveProfileService?,
         fireStoreService: IFirestoreService?) {
        self.themeManager = themeManager
        self.listenerService = listenerService
        self.palette = palette
        self.saveProfileService = saveProfileService
        self.fireStoreService = fireStoreService
    }
    
    func observeChannel(completion: @escaping (_ error: Error) -> Void) {
        listenerService?.channelObserve { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    // MARK: - Add new Channel
    
    func addChannel(completion: (UIAlertController) -> Void, scoup: @escaping (Bool) -> Void ) {
        
        let alert = UIAlertController(title: "Add shannel",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "New channel..."
        }
        
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = palette?.alertStyle ?? .light
            alert.textFields?.first?.backgroundColor = palette?.textFieldBackgroundColor
            alert.view.layer.shadowColor = palette?.labelColor.cgColor
            alert.view.layer.shadowOpacity = 0.5
            alert.view.layer.shadowRadius = 15
        } else {
            alert.textFields?.first?.backgroundColor = .white
            alert.textFields?.first?.textColor = .black
        }
        
        let addChannel = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            scoup(true)
            let text = alert.textFields?.first?.text
            self?.fireStoreService?.addNewChannel(text: text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            scoup(true)
        }
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
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: self?.palette?.labelColor ?? .white]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: self?.palette?.labelColor ?? .white]
            if #available(iOS 13.0, *) {
                UISearchTextField.appearance().attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.gray])
            }
            
            UIApplication.shared.keyWindow?.reload()
            UIApplication.shared.keyWindow?.reload()
            
            completion(self?.palette)
        }
    }
}
