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
    
    private var coreDataStack = ModernCoreDataStack()
    
    private var model: IModelConversationList?
    private var dataProvider: IChannelFRCDelegate?
    // Theme
    private var themeIsSaved: Bool = false {
        didSet {
            model?.changeTheme(completion: { [weak self] palette in
                self?.view.backgroundColor = palette?.backgroundColor
            })
        }
    }
    lazy var fetchResultController = FetchedResultController(coreDataStack: coreDataStack)
    lazy var tableViewDataSource: UITableViewDataSource = {
        return TableViewDataSourceChannels(fetchedResultController: fetchResultController, palette: ThemesService.currentTheme())
    }()
    
    @IBOutlet weak var tableView: UITableView?
        
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ModelConversationList(coreDataStack: coreDataStack)
        tableView?.dataSource = tableViewDataSource
        tableView?.delegate = self
        setBarButtonItems()
        setSearchController()
        configureData()
        
        model?.changeTheme(completion: { [weak self] palette in
            self?.view.backgroundColor = palette?.backgroundColor
        })
        model?.observeChannel(completion: { error in
            ErrorAlert.show(error.localizedDescription) { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    private func configureData() {
        guard let tableView = self.tableView else { return }
        dataProvider = ChannelFRCDelegate(delegate: tableView, frc: fetchResultController)
    }
    
    @IBAction func addNewChannel(_ sender: UIBarButtonItem) {
        model?.addChannel(completion: {[weak self] alert in
            self?.present(alert, animated: true)
        })
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
        
        themesVC.palette = ThemesService.currentTheme()
        themesVC.lastTheme = ThemesService.currentTheme() // for work CancelButton
        themesVC.clousure = { [weak self] theme in
            
            DispatchQueue.global(qos: .background).async {
                ThemesService.applyTheme(theme: theme) { [weak self ] isSaved in
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

// MARK: - NavigationItem setting
extension ConversationListViewController {
    
    func setBarButtonItems() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setProfileButton()
        setThemePickerButton()
    }
    
    func setProfileButton() {
        let button = ProfileButton()
        button.addTarget(self, action: #selector(profileAction), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func setThemePickerButton() {
        let button = ThemePickerButton()
        button.addTarget(self, action: #selector(settingAction), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
}

// MARK: - TableView Delegate

extension ConversationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let channel = fetchResultController.object(at: indexPath)
        let vc = ConversationViewController(coreDataStack: coreDataStack)
        let palette = ThemesService.currentTheme()
        vc.palette = palette
        vc.title = channel.name
        vc.channelID = channel.identifier ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let id = fetchResultController.object(at: indexPath).identifier else { return nil }
        
        let fireStoreService = FirestoreService(channelID: id)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
            fireStoreService.deleteChannel()
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
}

// MARK: - UISearchBarDelegate
extension ConversationListViewController: UISearchBarDelegate {
    
    private func setSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "name contains [cd] %@", searchText)
        updateFetchetResultController(for: predicate)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        updateFetchetResultController(for: nil)
    }
    
    private func updateFetchetResultController(for predicate: NSPredicate?) {
        fetchResultController.fetchRequest.predicate = predicate
        do { try fetchResultController.performFetch() } catch let error {
            print(error.localizedDescription)
        }
        tableView?.reloadData()
    }
}
