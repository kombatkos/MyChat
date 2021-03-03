//
//  ConversationViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var listMessages: [Messages] = [Messages(text: "Привет, как дела", outgoing: false), Messages(text: "Привет, все хорошо, а у тебя?", outgoing: true), Messages(text: "Тоже не плохо, идешь сегодня на роликах кататься?", outgoing: false), Messages(text: "Конечно!", outgoing: true)]
    
    enum Message: String {
        case income, outgoing
    }
    
    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        self.tableView?.register(IncomingCell.self, forCellReuseIdentifier: "IncomingCell")
        self.tableView?.register(OutgoingCell.self, forCellReuseIdentifier: "OutgoingCell")
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell", for: indexPath) as? OutgoingCell else { fatalError("can not get new cell")}
            cell.textMessageLabel.text = message.text ?? ""
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell", for: indexPath) as? IncomingCell else { fatalError("can not get new cell")}
            cell.textMessageLabel.text = message.text ?? ""
            return cell
        }
    }

    //MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
