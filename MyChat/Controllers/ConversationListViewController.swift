//
//  ConversationListViewController.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import UIKit

class ConversationListViewController: UIViewController {
    
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
    }
    
    @IBAction func profileAction(_ sender: UIBarButtonItem) {
        let profile = UIStoryboard(name: "Profile", bundle: nil)
        let destinationVC = profile.instantiateViewController(withIdentifier: "ProfileVC")
        present(destinationVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - TableView data source
extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
        { fatalError("Can not create cell") }
        var chats: MyChat?
        
        let sectionData = SectionsData(rawValue: indexPath.section)
        
        switch sectionData {
        case .online:
            chats = sectionData?.getOnlineChats(chats: chats2)?[indexPath.row]
        default:
            chats = sectionData?.getHistoryChats(chats: chats2)?[indexPath.row]
        }
        
        cell.avatarImageView?.image = #imageLiteral(resourceName: "appstore")
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
