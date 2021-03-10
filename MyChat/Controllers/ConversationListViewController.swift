//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationListViewController: UIViewController {
    
    var myFirstName: String? = "Marina"
    var myLastName: String? = "Dudarenko"
    
    var palette: PaletteProtocol?
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var filteredChats: [MyChat] = []
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    @IBOutlet weak var tableView: UITableView?
    
    enum SectionsData: Int, CaseIterable {
        case online, history
        
        func description() -> String {
            switch self {
            case .online:
                return "Online"
            case .history:
                return "History"
            }
        }
        func getOnlineChats(chats: [MyChat]?) ->[MyChat]? {
            return chats?.filter({$0.online})
        }
        func getHistoryChats(chats: [MyChat]?) ->[MyChat]?  {
            return chats?.filter({!$0.online})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTheme()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        setProfileButton()
        setThemePickerButton()
        
        //Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - Navigation
    
    @objc func profileAction() {
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        let destinationVC = profile.instantiateViewController(withIdentifier: "ProfileVC")
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func settingAction() {
        let themesVC = ThemesViewController()
        themesVC.lastTheme = ThemesManager.currentTheme()
        themesVC.clousure = { [weak self] theme in
            ThemesManager.applyTheme(theme: theme)
            self?.changeTheme()
        }
        navigationController?.pushViewController(themesVC, animated: true)
    }
}

//MARK: - Сhange Theme
extension ConversationListViewController {
    
    func changeTheme() {
        palette = ThemesManager.currentTheme()
        
        view.backgroundColor = palette?.backgroundColor ?? .white
        
        UITextField.appearance().backgroundColor = palette?.tableViewHeaderFooterColor
        UILabel.appearance().textColor = palette?.labelColor
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = palette?.tableViewHeaderFooterColor
        UITableViewCell.appearance().backgroundColor = palette?.backgroundColor
        UITableViewCell.appearance().selectedBackgroundView = palette?.cellSelectedView
        UITableView.appearance().backgroundColor = palette?.backgroundColor
        UINavigationBar.appearance().barStyle = palette?.barStyle ?? .default
        UIApplication.shared.keyWindow?.reload()
        UIApplication.shared.keyWindow?.reload()
    }
}

// MARK: - TableView data source
extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return filteredChats.count } else {
            let sectionData = SectionsData(rawValue: section)
            switch sectionData {
            case .online:
                return sectionData?.getOnlineChats(chats: chats)?.count ?? 0
            case .history:
                return sectionData?.getHistoryChats(chats: chats)?.count ?? 0
            case .none:
                return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        var chat: MyChat?
        
        if isFiltering { chat = filteredChats[indexPath.row] } else {
            
            let sectionData = SectionsData(rawValue: indexPath.section)
            switch sectionData {
            case .online:
                chat = sectionData?.getOnlineChats(chats: chats)?[indexPath.row]
            case .history:
                chat = sectionData?.getHistoryChats(chats: chats)?[indexPath.row]
            case .none:
                break
            }
        }
        
        cell.avatarImageView?.image = #imageLiteral(resourceName: "avatar.jpg")
        cell.dateLabel?.text = DateManager.getDate(date: chat?.date)
        cell.nameLabel?.text = chat?.name ?? "No Name"
        cell.messageLabel?.text = chat?.message
        cell.online = chat?.online ?? false
        cell.hasUnreadMessages = chat?.hasUnreadMessages ?? false
        
        return cell
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFiltering { return "Search"} else {
            let sectionData = SectionsData(rawValue: section)
            switch sectionData {
            case .online:
                return sectionData?.description()
            case .history:
                return sectionData?.description()
            case .none:
                return ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationIB = UIStoryboard(name: "Conversation", bundle: nil)
        let vc = conversationIB.instantiateViewController(withIdentifier: "ConversationVC")
        if isFiltering {
            vc.title = filteredChats[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let sectionData = SectionsData(rawValue: indexPath.section)
            switch sectionData {
            case .online:
                let selectionChat = sectionData?.getOnlineChats(chats: chats)?[indexPath.row]
                vc.title = selectionChat?.name
                navigationController?.pushViewController(vc, animated: true)
            case .history:
                let selectionChat = sectionData?.getHistoryChats(chats: chats)?[indexPath.row]
                vc.title = selectionChat?.name
                navigationController?.pushViewController(vc, animated: true)
            case .none: break
            }
        }
    }
    
}
//MARK: - NavigationItem setting
extension ConversationListViewController {
    
    private func setProfileButton() {
        var initiales = "NO"
        if let firstWord = myFirstName?.first?.uppercased(),
           let lastWord = myLastName?.first?.uppercased() {
            initiales = "\(firstWord)\(lastWord)"
        }
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 17.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle(initiales, for: UIControl.State.normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(profileAction), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func setThemePickerButton() {
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.layer.cornerRadius = 20
        button.setImage(#imageLiteral(resourceName: "graySetting"), for: .normal)
        button.addTarget(self, action: #selector(settingAction), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
}

//MARK: - UISearchResultsUpdating
extension ConversationListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText)
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredChats = chats?.filter({($0.name?.contains(searchText) ?? false)
        }) ?? []
        tableView?.reloadData()
    }
}
