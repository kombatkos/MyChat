//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {
    
    // Dependenses
    var palette: PaletteProtocol?
    var listenerSerice: ListenerService?
    var coreDataStack: ModernCoreDataStack
    
    // Properties
    
    var channelID = ""
    var messageBar = MessageBar()
    
    var tableView = UITableView()
    
    lazy var tableViewDataSourse: UITableViewDataSource = {
        let appID = listenerSerice?.appID ?? ""
        let request: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "channel.identifier = %@", channelID)
        
        let context = coreDataStack.container.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: "Messages")
        fetchResultController.delegate = self
        
        return TableViewDataSourseConversation(fetchedResultController: fetchResultController, palette: ThemesManager.currentTheme(), appID: appID)
    }()
    
    // MARK: - Life cicle
    
    init(coreDataStack: ModernCoreDataStack) {
        self.coreDataStack = coreDataStack
        listenerSerice = ListenerService(coreDataStack: coreDataStack)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        messageBar.backgroundColor = palette?.conversationBottomViewColor ?? .lightGray
        view.backgroundColor = palette?.backgroundColor ?? .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = tableViewDataSourse
        tableView.register(IncomingCell.self, forCellReuseIdentifier: "IncomingCell")
        tableView.register(OutgoingCell.self, forCellReuseIdentifier: "OutgoingCell")
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        let contentInset: CGFloat = 60
        tableView.contentInset.bottom = contentInset
        tableView.contentInset.top -= contentInset
        registerForKeyboardNotification()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendMessage))
        messageBar.messageTextView.sendButton.addGestureRecognizer(tap)
        
        listenerSerice?.messagesObserve(channelID: channelID) { error in
            if let error = error {
                ErrorAlert.show(error.localizedDescription) { [weak self] (alert) in
                        self?.present(alert, animated: true)
                }
            }
        }
    }
    
    deinit {
        removeForKeyboardNotification()
        var shouldLogTextAnalyzer = false
        if ProcessInfo.processInfo.environment["deinit_log"] == "verbose" {
            shouldLogTextAnalyzer = true
        }
        if shouldLogTextAnalyzer { print("Deinit ConversationViewController") }
    }
    
    // MARK: - Actions
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        messageBar.messageTextView.resignFirstResponder()
    }
    
    @objc func sendMessage() {
        let firesoreService = FirestoreService(channelID: channelID)
        let profileService = SaveProfileService(fileManager: FilesManager())
        
        profileService.loadProfile { [weak self] profile in
            guard let newMessage = self?.messageBar.messageTextView.text else { return }
            guard let id = self?.listenerSerice?.appID else { return }
            let message = newMessage.trim()
            if !message.isBlank {
                let message = Message(content: newMessage, created: Date(), senderId: id, senderName: profile?.name ?? "Incognito")
                firesoreService.sendMessage(message: message)
                self?.messageBar.messageTextView.text = ""
            }
        }
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("INSERT")
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            print("DELETE")
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            print("MOVE")
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            print("UPDATE")
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - TableView Delegate
extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Setup Constraints
extension ConversationViewController {
    
    private func setupConstraint() {
        messageBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageBar)
        messageBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
