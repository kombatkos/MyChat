//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit
import CoreData

protocol ConversationListVCDelegate: class {
    func reloadData()
    func setProfileButton()
}

class ConversationListViewController: UIViewController, ConversationListVCDelegate {
    
    // MARK: - Properties
    
    // Dependenses
    private var palette: PaletteProtocol?
    private var coreDataStack = ModernCoreDataStack()
    private var request: MyChatRequest?
    private var listenerService: ListenerService?
    
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
    
    var searchPredicate: NSPredicate?
    
    lazy var fetchResultController: NSFetchedResultsController<ChannelCD> = {
        let request: NSFetchRequest<ChannelCD> = ChannelCD.fetchRequest()
        let lastActivitySDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        let nameSDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [lastActivitySDescriptor, nameSDescriptor]
        request.predicate = searchPredicate
        let context = coreDataStack.container.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: "Channels")
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    lazy var tableViewDataSource: UITableViewDataSource = {
        return TableViewDataSourceChannels(fetchedResultController: fetchResultController, palette: ThemesManager.currentTheme())
    }()
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = tableViewDataSource
        tableView?.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        changeTheme()
        setProfileButton()
        setThemePickerButton()
        setSearchController()
        
        listenerService = ListenerService(coreDataStack: coreDataStack)
        listenerService?.channelObserve { [weak self] error in
            if let error = error {
                ErrorAlert.show(error.localizedDescription) { [weak self] (alert) in
                    self?.present(alert, animated: true)
                }
            }
        }
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

extension ConversationListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("INSERT")
            guard let newIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            print("DELETE")
            guard let indexPath = indexPath else { return }
            tableView?.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            print("MOVE")
            guard let indexPath = indexPath else { return }
            tableView?.deleteRows(at: [indexPath], with: .automatic)
            guard let newIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            print("UPDATE")
            guard let indexPath = indexPath else { return }
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
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
        vc.palette = palette
        if isFiltering {
            vc.title = filteredChannels?[indexPath.row].name
            vc.channelID = filteredChannels?[indexPath.row].identifier ?? ""
            navigationController?.pushViewController(vc, animated: true)
        } else {
            vc.title = channel.name
            vc.channelID = channel.identifier ?? ""
            navigationController?.pushViewController(vc, animated: true)
        }
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
        searchPredicate = NSPredicate(format: "name = %@", searchText)
//        filteredChannels = channels?.filter({ ($0.name.contains(searchText.lowercased())) })
        tableView?.reloadData()
    }
}
