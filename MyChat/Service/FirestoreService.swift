//
//  FirestoreService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 22.03.2021.
//

import UIKit
import FirebaseFirestore

class FirestoreService {
    
    var channelID: String
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    init(channelID: String) {
        self.channelID = channelID
    }
    
    func sendMessage(message: Message) {
        let messagesRef = reference.document(channelID).collection("messages")
        let dictionary: [String: Any] = ["senderName": message.senderName,
                                         "content": message.content,
                                         "created": Timestamp(date: message.created),
                                         "senderId": message.senderId]
        
        messagesRef.addDocument(data: dictionary)
    }
    
    func addNewChannel(completion: (UIAlertController) -> Void) {
        let alert = UIAlertController(title: "Add shannel", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.backgroundColor = .white
            alert.textFields?.first?.textColor = .black
            textField.placeholder = "New channel..."
        }
        let addChannel = UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            self.reference.addDocument(data: ["name": text])
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(addChannel)
        
        completion(alert)
    }
    
}
