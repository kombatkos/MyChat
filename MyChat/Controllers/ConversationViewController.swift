//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
    
    // Dependenses
    var palette: PaletteProtocol?
    let listenerSerice = ListenerService()
    var coreDataStack: CoreDataStack
    
    // Properties
    
    var channelID = ""
    
    var listMessages: [Message] = []
    
    var tableView = UITableView()
    var messageBar = MessageBar()
    
    // MARK: - Life cicle
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
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
        tableView.dataSource = self
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
        
        listenerSerice.messagesObserve(channelID: channelID) { [weak self] result in
            switch result {
            case .success((let message, let identifier)):
                self?.listMessages = message
                self?.listMessages.sort(by: { (message1, message2) -> Bool in
                    message1.created > message2.created
                })
                self?.tableView.reloadData()
                self?.saveMessages(identifier: identifier)
            case .failure(let error):
                ErrorAlert.show(error.localizedDescription) { [weak self] (alert) in
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func saveMessages(identifier: String) {
        let request = MyChatRequest(coreDataStack: coreDataStack)
        request.saveMessageRequest(channelID: self.channelID, messages: self.listMessages, messageID: identifier)
    }
    
    deinit {
        removeForKeyboardNotification()
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
            guard let id = self?.listenerSerice.appID else { return }
            let message = newMessage.trim()
            if !message.isBlank {
                let message = Message(content: newMessage, created: Date(), senderId: id, senderName: profile?.name ?? "Incognito")
                firesoreService.sendMessage(message: message)
                self?.messageBar.messageTextView.text = ""
            }
        }
    }
}

// MARK: - TableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = listMessages[indexPath.row]
        
        if message.senderId == listenerSerice.appID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell", for: indexPath) as? OutgoingCell else { return UITableViewCell()}
            cell.textMessageLabel.text = message.content
            cell.dateLabel.text = DateManager.getDate(date: message.created)
            cell.palette = palette
            cell.selectionStyle = .none
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell", for: indexPath) as? IncomingCell else { return UITableViewCell() }
            cell.textMessageLabel.text = message.content
            cell.dateLabel.text = DateManager.getDate(date: message.created)
            cell.nameLabel.text = message.senderName
            cell.palette = palette
            cell.selectionStyle = .none
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
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
