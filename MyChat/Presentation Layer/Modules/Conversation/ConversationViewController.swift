//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    // Dependenses
    var palette: PaletteProtocol?
    var model: IModelConversation?
    // Properties
    
    var channelID = ""
    var messageBar: MessageBar?
    private var dataProvider: IMessageFRCDelegate?
    var tableView = UITableView()
    var backgroundImageView = UIImageView()
    
    var fetchedResultController: MessageFetchetResultController
    
    var tableViewDataSourse: UITableViewDataSource
    
    // MARK: - Init
    
    init(channelID: String,
         palette: PaletteProtocol?,
         fetchedResultController: MessageFetchetResultController,
         listenerSerice: IListenerService,
         tableViewDataSourse: UITableViewDataSource,
         model: IModelConversation?) {
        
        self.channelID = channelID
        self.palette = palette
        self.fetchedResultController = fetchedResultController
        self.tableViewDataSourse = tableViewDataSourse
        self.model = model
        messageBar = MessageBar(palette: palette)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = palette?.conversationBackground
        view.backgroundColor = palette?.backgroundColor ?? .white
        navigationItem.largeTitleDisplayMode = .never
        setupConstraint()
        registerForKeyboardNotification()
        
        configureMessageBar()
        configureTableView()
        configureData()
        
        model?.observeMessages(completion: { [weak self] error in
            ErrorAlert.show(error.localizedDescription) { [weak self] (alert) in
                self?.present(alert, animated: true)
            }
        })
    }
    
    deinit {
        //        listener?.remove()
        removeForKeyboardNotification()
        var shouldLogTextAnalyzer = false
        if ProcessInfo.processInfo.environment["deinit_log"] == "verbose" {
            shouldLogTextAnalyzer = true
        }
        if shouldLogTextAnalyzer { print("Deinit ConversationViewController") }
    }
    
    // MARK: - Configure
    
    private func configureMessageBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendMessage))
        messageBar?.messageTextView?.sendButton.addGestureRecognizer(tap)
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = tableViewDataSourse
        tableView.register(IncomingCell.self, forCellReuseIdentifier: "IncomingCell")
        tableView.register(OutgoingCell.self, forCellReuseIdentifier: "OutgoingCell")
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        let contentInset: CGFloat = 60
        tableView.contentInset.bottom = contentInset
        tableView.contentInset.top -= contentInset
    }
    
    private func configureData() {
        dataProvider = MessageFRCDelegate(delegate: tableView, frc: fetchedResultController)
    }
    
    // MARK: - Actions
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        messageBar?.messageTextView?.resignFirstResponder()
    }
    
    @objc func sendMessage() {
        let text = messageBar?.messageTextView?.text
        model?.sendMessage(text: text, completion: { sended in
            if sended { self.messageBar?.messageTextView?.text = "" }
        })
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
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        messageBar?.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(messageBar ?? UIView())
        messageBar?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageBar?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageBar?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: messageBar?.topAnchor ?? view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.backgroundColor = .clear
    }
}
