//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

protocol ConversationListVCDelegate {
    func reloadData()
    func setProfileButton()
}

class ConversationListViewController: EmitterViewController, ConversationListVCDelegate {
    
    // MARK: - Properties
    var assembly: PresentationAssembly?
    
    private var dataProvider: IChannelFRCDelegate?
    // Theme
    private var palette: PaletteProtocol?
    private var themeIsSaved: Bool = false {
        didSet {
            model?.changeTheme(completion: { [weak self] palette in
                self?.palette = palette
                self?.view.backgroundColor = palette?.backgroundColor
                self?.tableView?.reloadData()
            })
        }
    }
    
    var model: IModelConversationList?
    
    lazy var transitionManager: ITransitionManager? = {
        return assembly?.transitionManager()
    }()
    lazy var fetchResultController: FetchedResultController? = {
        return assembly?.fetchedResultControllerChannels()
    }()
    lazy var tableViewDataSource: TableViewDataSourceChannels? = {
        return assembly?.channelDataSource(frc: fetchResultController)
    }()
    
    @IBOutlet weak var tableView: UITableView?
        
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembly = PresentationAssembly()
        model = assembly?.modelConversationList()
        tableView?.dataSource = tableViewDataSource
        tableView?.delegate = self
        setBarButtonItems()
        setSearchController()
        configureData()
        
        model?.changeTheme(completion: { [weak self] palette in
            self?.view.backgroundColor = palette?.backgroundColor
            self?.tableView?.reloadData()
        })
        model?.observeChannel(completion: { error in
            ErrorAlert.show(error.localizedDescription) { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    private func configureData() {
        guard let tableView = self.tableView else { return }
        guard let frc = fetchResultController else { return }
        dataProvider = ChannelFRCDelegate(delegate: tableView, frc: frc)
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
        guard let vc = assembly?.assemblyProfileVC() else { return }
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionManager
        present(vc, animated: true)
    }
    
    @objc func settingAction() {
        let themesVC = assembly?.assemblyThemesVC()
//        themesVC?.palette = palette
        themesVC?.lastTheme = palette // for work CancelButton
        themesVC?.clousure = { [weak self] theme in
            
            DispatchQueue.global(qos: .utility).async {
                self?.assembly?.themeService().applyTheme(theme: theme) { [weak self ] isSaved in
                    self?.themeIsSaved = isSaved
                }
            }
            return theme
        }
        guard let vc = themesVC else { return }
        navigationController?.pushViewController(vc, animated: true)
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
        let button = ProfileButton(saveService: model?.saveProfileService)
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
        
        let channel = fetchResultController?.object(at: indexPath)
        guard let id = channel?.identifier else { return }
        let vc = assembly?.assemblyConversationVC(channelID: id)
        let palette = self.palette
        vc?.palette = palette
        vc?.title = channel?.name
        vc?.channelID = channel?.identifier ?? ""
        guard let vc1 = vc else { return }
        navigationController?.pushViewController(vc1, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let id = fetchResultController?.object(at: indexPath).identifier else { return nil }
        
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
        fetchResultController?.fetchRequest.predicate = predicate
        do { try fetchResultController?.performFetch() } catch let error {
            print(error.localizedDescription)
        }
        tableView?.reloadData()
    }
}
