//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

protocol ConversationListVCDelegate: class {
    func reloadData()
    func setProfileButton()
}

class ConversationListViewController: UIViewController, ConversationListVCDelegate {
    
    // MARK: - Properties
    
    // Dependenses
    private var palette: PaletteProtocol?
    private let listenerService = ListenerService()
    private var coreDataStack = CoreDataStack()
    private var request: MyChatRequest?
    
    // Theme
    private var themeIsSaved: Bool = false {
        didSet { changeTheme() }
    }
    
    // Search controller
    private var searchController = UISearchController(searchResultsController: nil)
    private var filteredChannels: [Channel]?
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var channels = [Channel]()
    private lazy var saveChannel: Void = {
        saveChat()
    }()
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        changeTheme()
        setProfileButton()
        setThemePickerButton()
        setSearchController()
        
        coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistice()
        }
        coreDataStack.enableObservers()
        
//        listenerService.channelObserve { [weak self] (result) in
//            switch result {
//            case .success(let channels):
//                self?.channels = channels
//                self?.channels?.sort(by: { (first, last) -> Bool in
//                    let defaulDate = Date(timeIntervalSince1970: 99)
//                    return (first.lastActivity ?? defaulDate > last.lastActivity ?? defaulDate)
//                })
//                self?.tableView?.reloadData()
//                _ = self?.saveChannel
//            case .failure(let error):
//                ErrorAlert.show(error.localizedDescription) { [weak self] (alert) in
//                    self?.present(alert, animated: true)
//                }
//            }
//        }
        listenerService.channelObserve2(channels: channels) { [weak self] (result) in
            switch result {
            case .success(let channels):
                self?.channels = channels
                self?.channels.sort(by: { (first, last) -> Bool in
                    let defaulDate = Date(timeIntervalSince1970: 99)
                    return (first.lastActivity ?? defaulDate > last.lastActivity ?? defaulDate)
                })
                self?.tableView?.reloadData()
                self?.saveChat()
            case .failure(let error):
                ErrorAlert.show(error.localizedDescription) { [weak self] (alert) in
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    deinit {
        saveChat()
    }
    
    // MARK: - Actions
    private func saveChat() {
        request = MyChatRequest(coreDataStack: coreDataStack)
        request?.saveChannelRequest(channels: self.channels)
    }
    
    @IBAction func addNewChannel(_ sender: UIBarButtonItem) {
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
        
        present(alert, animated: true)
    }
    
    func reloadData() {
        tableView?.reloadData()
    }
    
    // MARK: - Navigation
    
    @objc func profileAction() {
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        guard let destinationVC = profile.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController else { return }
        destinationVC.delegate = self
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func settingAction() {
        let themesVC = ThemesViewController()
        
        themesVC.palette = ThemesManager.currentTheme()
        themesVC.lastTheme = ThemesManager.currentTheme() // for work CancelButton
        themesVC.clousure = { [weak self] theme in
            
            DispatchQueue.global(qos: .background).async {
                ThemesManager.applyTheme(theme: theme) { [weak self ] isSaved in
                    self?.themeIsSaved = isSaved
                    DispatchQueue.main.async {
                        self?.tableView?.reloadData()
                    }
                }
            }
            return theme
        }
        navigationController?.pushViewController(themesVC, animated: true)
    }
}

// MARK: - Сhange Theme
extension ConversationListViewController {
    
    func changeTheme() {
        DispatchQueue.main.async { [weak self] in
            self?.palette = ThemesManager.currentTheme()
            
            self?.view.backgroundColor = self?.palette?.backgroundColor ?? .white
            
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

// MARK: - TableView data source
extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return filteredChannels?.count ?? 0 } else {
            return channels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        var channel: Channel?
        
        if isFiltering { channel = filteredChannels?[indexPath.row] } else {
            channel = self.channels[indexPath.row]
        }
        cell.avatarImageView?.image = #imageLiteral(resourceName: "tv")
        cell.dateLabel?.text = DateManager.getDate(date: channel?.lastActivity)
        cell.nameLabel?.text = channel?.name
        cell.messageLabel?.text = channel?.lastMessage
        cell.palette = palette
        cell.avatarImageView?.backgroundColor = .random()
        
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFiltering { return "Search"} else {
            return "Channels"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ConversationViewController(coreDataStack: coreDataStack)
        vc.palette = palette
        if isFiltering {
            vc.title = filteredChannels?[indexPath.row].name
            vc.channelID = filteredChannels?[indexPath.row].identifier ?? ""
            navigationController?.pushViewController(vc, animated: true)
        } else {
            vc.title = channels[indexPath.row].name
            vc.channelID = channels[indexPath.row].identifier
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var channelID = ""
        if isFiltering {
            guard let id = filteredChannels?[indexPath.row].identifier
            else { fatalError("failed to get channelID ") }
            channelID = id
        } else {
            let id = channels[indexPath.row].identifier
            channelID = id
        }
        let fireStoreService = FirestoreService(channelID: channelID)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]_, _, _  in
            fireStoreService.deleteChannel()
            if self?.isFiltering == true {
                self?.filteredChannels?.remove(at: indexPath.row)
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
}
// MARK: - NavigationItem setting
extension ConversationListViewController {
    
    private func getInitiales(completion: @escaping (String?) -> Void) {
        SaveProfileService(fileManager: FilesManager()).loadProfile { (profile) in
            var initiales = ""
            if let fullNameArr = profile?.name?.split(separator: " ") {
                if fullNameArr.count > 0 {
                    guard let firstWord = fullNameArr[0].first else { return }
                    initiales += String(firstWord)
                }
                if fullNameArr.count > 1 {
                    guard let firstWord = fullNameArr[1].first else { return }
                    initiales += String(firstWord)
                }
            }
            completion(initiales)
        }
    }
    
    func setProfileButton() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 17.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(self.profileAction), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let barButton = UIBarButtonItem(customView: button)
        
        getInitiales { [weak self] initiales in
            if let initiales = initiales, initiales != "" {
                button.setTitle(initiales, for: UIControl.State.normal)
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(.white, for: .highlighted)
                self?.navigationItem.rightBarButtonItem = barButton
            } else {
                button.setImage(#imageLiteral(resourceName: "avatarSmall"), for: .normal)
                button.clipsToBounds = true
                self?.navigationItem.rightBarButtonItem = barButton
            }
        }
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

// MARK: - UISearchResultsUpdating
extension ConversationListViewController: UISearchResultsUpdating {
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearchText(searchText)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredChannels = channels.filter({ ($0.name.contains(searchText.lowercased())) })
        tableView?.reloadData()
    }
}
