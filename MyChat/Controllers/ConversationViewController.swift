//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var palette: PaletteProtocol?
    
    var listMessages: [Messages] = [ Messages(text: "Конечно!", outgoing: true),
                                    Messages(text: "Тоже не плохо, идешь сегодня на роликах кататься?", outgoing: false),
                                    Messages(text: "Привет, все хорошо, а у тебя?", outgoing: true),
                                    Messages(text: "Привет, как дела", outgoing: false)]
    
    var tableView = UITableView()
    var messageBar = MessageBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        messageBar.backgroundColor = palette?.conversationBottomViewColor ?? .red
        view.backgroundColor = palette?.backgroundColor ?? .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IncomingCell.self, forCellReuseIdentifier: "IncomingCell")
        tableView.register(OutgoingCell.self, forCellReuseIdentifier: "OutgoingCell")
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        registerForKeyboardNotification()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendMessage))
        messageBar.messageTextField.rightView?.addGestureRecognizer(tap)
    }
    
    deinit {
        removeForKeyboardNotification()
    }
    
    @objc func sendMessage() {
        let newMessage = messageBar.messageTextField.text
        if newMessage != "" {
            listMessages.insert(Messages(text: newMessage, outgoing: true), at: 0)
            messageBar.messageTextField.text = ""
            tableView.reloadData()
        }
    }
}

//MARK: - TableView DataSource

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = listMessages[indexPath.row]
        
        if message.outgoing {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell", for: indexPath) as? OutgoingCell else { return UITableViewCell()}
            cell.textMessageLabel.text = message.text ?? ""
            cell.palette = palette
            cell.selectionStyle = .none
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell", for: indexPath) as? IncomingCell else { return UITableViewCell() }
            cell.textMessageLabel.text = message.text ?? ""
            cell.palette = palette
            cell.selectionStyle = .none
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
    }

    //MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Setup Constraints
extension ConversationViewController {
    
    private func setupConstraint() {
        messageBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageBar)
        messageBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messageBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: messageBar.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}


