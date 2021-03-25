//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationListViewController: UIViewController {
    
    // MARK: - Properties
    
    // Dependenses
    private var palette: PaletteProtocol?
    private let listenerService = ListenerService()
    
    // Theme
    private var themeIsSaved: Bool = false {
        didSet { changeTheme() }
    }
    
    // Search controller
    private var searchController = UISearchController(searchResultsController: nil)
    private var filteredChats = [Channel]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var channels = [Channel]()
    
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
        
        listenerService.channelObserve { [weak self] (result) in
            switch result {
            case .success(let channels):
                self?.channels = channels
                self?.channels.sort(by: { (first, last) -> Bool in
                    let defaulDate = Date(timeIntervalSince1970: 99)
                    return (first.lastActivity ?? defaulDate > last.lastActivity ?? defaulDate)
                })
                self?.tableView?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addNewChannel(_ sender: UIBarButtonItem) {
        let fireStoreService = FirestoreService(channelID: "")
        fireStoreService.addNewChannel { alert in
            present(alert, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    @objc func profileAction() {
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        let destinationVC = profile.instantiateViewController(withIdentifier: "ProfileVC")
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
        if isFiltering { return filteredChats.count } else {
            return channels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        var channel: Channel?
        
        if isFiltering { channel = filteredChats[indexPath.row] } else {
            channel = self.channels[indexPath.row]
        }
        cell.avatarImageView?.image = #imageLiteral(resourceName: "tv")
        cell.dateLabel?.text = DateManager.getDate(date: channel?.lastActivity)
        cell.nameLabel?.text = channel?.name
        cell.messageLabel?.text = channel?.lastMessage
        cell.palette = palette
        
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
        
        let vc = ConversationViewController()
        vc.palette = palette
        if isFiltering {
            vc.title = filteredChats[indexPath.row].name
            vc.channelID = filteredChats[indexPath.row].identifier
            navigationController?.pushViewController(vc, animated: true)
        } else {
            vc.title = channels[indexPath.row].name
            vc.channelID = channels[indexPath.row].identifier
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
}
// MARK: - NavigationItem setting
extension ConversationListViewController {
    
    private func getInitiales(completion: @escaping (String?) -> Void) {
        SaveProfileService(fileManager: FilesManager()).loadProfile { (profile) in
            var initiales = ""
            if let fullNameArr = profile?.name?.split(separator: " ") {
                if fullNameArr.count > 0 && profile?.avatarImage == nil {
                    guard let firstWord = fullNameArr[0].first else { return }
                    initiales += String(firstWord)
                }
                if fullNameArr.count > 1 {
                    guard let firstWord = fullNameArr[1].first else { return }
                    initiales += String(firstWord)
                }
                completion(initiales)
            }
        }
    }
    
    private func setProfileButton() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 17.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(self.profileAction), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let barButton = UIBarButtonItem(customView: button)
        
        getInitiales {  initiales in
            if let initiales = initiales, initiales != "" {
                button.setTitle(initiales, for: UIControl.State.normal)
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(.white, for: .highlighted)
                self.navigationItem.rightBarButtonItem = barButton
            } else {
                button.setImage(#imageLiteral(resourceName: "avatarSmall"), for: .normal)
                button.clipsToBounds = true
                self.navigationItem.rightBarButtonItem = barButton
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
        
        filteredChats = channels.filter({ ($0.name.contains(searchText.lowercased())) })
        tableView?.reloadData()
    }
}
