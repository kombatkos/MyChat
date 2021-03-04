//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationListViewController: UIViewController {
    
    var myFirstName: String? = "Marina"
    var myLastName: String? = "Dudarenko"
    
    @IBOutlet weak var tableView: UITableView?
    
    enum SectionsData: Int, CaseIterable {
        case online, history
        
        func description() -> String {
            switch self {
            case .online:
                return "Online"
            case .history:
                return "History"
            }
        }
        func getOnlineChats(chats: [MyChat]?) ->[MyChat]? {
            return chats?.filter({$0.online})
        }
        func getHistoryChats(chats: [MyChat]?) ->[MyChat]?  {
            return chats?.filter({!$0.online})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        setProfileButton()
    }
    
    @objc func profileAction() {
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        let destinationVC = profile.instantiateViewController(withIdentifier: "ProfileVC")
        present(destinationVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - TableView data source
extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionData = SectionsData(rawValue: section)
        switch sectionData {
        case .online:
            return sectionData?.getOnlineChats(chats: chats2)?.count ?? 0
        case .history:
            return sectionData?.getHistoryChats(chats: chats2)?.count ?? 0
        case .none:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else
        { return UITableViewCell() }
        var chats: MyChat?
        
        let sectionData = SectionsData(rawValue: indexPath.section)
        
        switch sectionData {
        case .online:
            chats = sectionData?.getOnlineChats(chats: chats2)?[indexPath.row]
        default:
            chats = sectionData?.getHistoryChats(chats: chats2)?[indexPath.row]
        }
        
        cell.avatarImageView?.image = #imageLiteral(resourceName: "avatar.jpg")
        cell.dateLabel?.text = DateManager.getDate(date: chats?.date)
        cell.nameLabel?.text = chats?.name ?? "No Name"
        cell.messageLabel?.text = chats?.message
        cell.online = chats?.online ?? false
        cell.hasUnreadMessages = chats?.hasUnreadMessages ?? false
        
        return cell
    }
    
//MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionData = SectionsData(rawValue: section)
        switch sectionData {
        
        case .online:
            return sectionData?.description()
        case .history:
            return sectionData?.description()
        case .none:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let conversationIB = UIStoryboard(name: "Conversation", bundle: nil)
        let vc = conversationIB.instantiateViewController(withIdentifier: "ConversationVC")
        
        let sectionData = SectionsData(rawValue: indexPath.section)
        switch sectionData {
        
        case .online:
            let selectionChat = sectionData?.getOnlineChats(chats: chats2)?[indexPath.row]
            vc.title = selectionChat?.name
            navigationController?.pushViewController(vc, animated: true)
        case .history:
            let selectionChat = sectionData?.getHistoryChats(chats: chats2)?[indexPath.row]
            vc.title = selectionChat?.name
            navigationController?.pushViewController(vc, animated: true)
        case .none: break
        }
    }
    
}
//MARK: - Setting UI elements
extension ConversationListViewController {
    
    private func setProfileButton() {
        var initiales = "NO"
        if let firstWord = myFirstName?.first?.uppercased(),
           let lastWord = myLastName?.first?.uppercased() {
            initiales = "\(firstWord)\(lastWord)"
        }
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle(initiales, for: UIControl.State.normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(profileAction), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
}
