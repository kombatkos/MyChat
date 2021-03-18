//
//  GCDProfileService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.03.2021.
//

import Foundation

class GCDProfileService: ProfileService {
    
    private let fileManager: FilesManager
    var item: DispatchWorkItem?
    let queue = DispatchQueue.global()
    
    init(fileManager: FilesManager) {
        self.fileManager = fileManager
    }
    
    func loadProfile(completion: @escaping (Profile?)->()) {
        let loadQueue = DispatchQueue(label: "tinkoff.konstantin.global",
                                      target: .global(qos: .userInitiated))
        loadQueue.async {
            let profile = self.fileManager.readFiles(fileName: "name.txt", fileAboutMe: "aboutMe.txt", fileImage: "image.png")
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }
    
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> ()) {
        
        item = DispatchWorkItem {
            if self.item?.isCancelled ?? true { completion(false); return }
            
            do {
                try self.fileManager.writeFiles(profile: profile, fileName: "name.txt", fileAboutMe: "aboutMe.txt", fileImage: "image.png")
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            self.item = nil 
        }
        queue.async {
            sleep(2)
            if self.item == nil {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            self.item?.perform()
        }
    }
    
    func cancel() {
        queue.asyncAfter(deadline: .now() ) { [weak self] in
            self?.item?.cancel()
            self?.item = nil
        }
    }
    
}
