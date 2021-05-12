//
//  TableViewDataSourseConversation.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 08.04.2021.
//

import UIKit
import CoreData

class TableViewDataSourseConversation: NSObject, UITableViewDataSource {
    
    let fetchedResultController: NSFetchedResultsController<MessageCD>
    let palette: PaletteProtocol?
    let appID: String
    
    init(fetchedResultController: NSFetchedResultsController<MessageCD>,
         palette: PaletteProtocol?,
         appID: String) {
        
        self.fetchedResultController = fetchedResultController
        self.palette = palette
        self.appID = appID
        super.init()
        performFetch()
    }
    
    func performFetch() {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Non fetched result controller perform")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else {
            fatalError("No section in fetchedResultController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = fetchedResultController.object(at: indexPath)
        
        if message.senderID == appID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell", for: indexPath) as? OutgoingCell else { return UITableViewCell()}
            cell.textMessageLabel.text = message.content
            cell.dateLabel.text = message.created?.dateToString()
            cell.palette = palette
            cell.selectionStyle = .none
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell", for: indexPath) as? IncomingCell else { return UITableViewCell() }
            cell.textMessageLabel.text = message.content
            cell.dateLabel.text = message.created?.dateToString()
            cell.nameLabel.text = message.senderName
            cell.palette = palette
            cell.selectionStyle = .none
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
    }
}
