//
//  TableViewDataSource.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 07.04.2021.
//

import UIKit
import CoreData

class TableViewDataSourceChannels: NSObject, UITableViewDataSource {
    
    let fetchedResultController: NSFetchedResultsController<ChannelCD>?
    let palette: PaletteProtocol
    
    init(fetchedResultController: NSFetchedResultsController<ChannelCD>?,
         palette: PaletteProtocol) {
        self.fetchedResultController = fetchedResultController
        self.palette = palette
        super.init()
        performFetch()
    }
    
    func performFetch() {
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print("Non fetched result controller perform")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else {
            fatalError("No section in fetchedResultController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        let channel = fetchedResultController?.object(at: indexPath)
        
        cell.avatarImageView?.image = #imageLiteral(resourceName: "tv")
        cell.dateLabel?.text = channel?.lastActivity?.dateToString()
        cell.nameLabel?.text = channel?.name
        cell.messageLabel?.text = channel?.lastMessage
        cell.palette = palette
        cell.avatarImageView?.backgroundColor = .random()
        
        return cell
    }
    
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Channels"
        }
}
