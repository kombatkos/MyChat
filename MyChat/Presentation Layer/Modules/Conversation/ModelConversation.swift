//
//  ConversationModel.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.04.2021.
//

import UIKit

protocol IModelConversation {
    var channelID: String {get}
    func observeMessages(completion: @escaping (_ error: Error) -> Void)
    func sendMessage(text: String?, completion: @escaping (_ sended: Bool) -> Void)
}

class ModelConversation: IModelConversation {
    
    var channelID: String
    let listenerSerice: IListenerService
    let firesoreService: IFirestoreService
    let profileService: ISaveProfileService
    
    init(channelID: String,
         listenerSerice: IListenerService,
         firesoreService: IFirestoreService,
         profileService: ISaveProfileService) {
        
        self.channelID = channelID
        self.listenerSerice = listenerSerice
        self.firesoreService = firesoreService
        self.profileService = profileService
    }
    
    func observeMessages(completion: @escaping (_ error: Error) -> Void) {
        _ = listenerSerice.messagesObserve(channelID: channelID) { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    func sendMessage(text: String?, completion: @escaping (_ sended: Bool) -> Void) {
    
        profileService.loadProfile { [weak self] profile in
            guard let newMessage = text else { return }
            let appID = UIDevice.current.identifierForVendor?.uuidString
            guard let id = appID else { return }
            let message = newMessage.trim()
            if !message.isBlank {
                let message = Message(content: newMessage, created: Date(), senderId: id, senderName: profile?.name ?? "Incognito")
                self?.firesoreService.sendMessage(message: message)
                completion(true)
            }
        }
    }
}
