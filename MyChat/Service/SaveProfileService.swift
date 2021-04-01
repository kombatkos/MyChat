//
//  OperationProfileService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.03.2021.
//

import Foundation

class SaveProfileService: ProfileService {
    
    let fileManager: FilesManager?
    let queue = OperationQueue()
    
    init(fileManager: FilesManager, isCancel: Bool = false) {
        self.fileManager = fileManager
    }
    
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> Void) {
        
        let saveOperation = SaveProfileOperation(profile: profile, fileManager: FilesManager())
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                if saveOperation.saved {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        queue.addOperation(saveOperation)
    }
    
    func loadProfile(completion: @escaping (Profile?) -> Void) {
        let loadOperation = LoadProfileOperation(fileManager: FilesManager())
        loadOperation.qualityOfService = .userInitiated
        
        loadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(loadOperation.profile)
            }
        }
        OperationQueue.main.addOperation(loadOperation)
    }
    
    func cancel() {
        queue.cancelAllOperations()
    }
}

class SaveProfileOperation: Operation {
    var saved = false
    var profile: Profile
    var fileManager: FilesManager
    
    init(profile: Profile, fileManager: FilesManager) {
        self.profile = profile
        self.fileManager = fileManager
        super.init()
    }
    override func main() {
        do {
            try fileManager.writeFiles(profile: profile, fileName: FileNames.name,
                                       fileAboutMe: FileNames.aboutMe, fileImage: FileNames.image)
            self.saved = true
        } catch {
            self.saved = false
        }
    }
}

class LoadProfileOperation: Operation {
    
    var fileManager: FilesManager
    var profile: Profile?
    
    init(fileManager: FilesManager) {
        self.fileManager = fileManager
        super.init()
    }
    
    override func main() {
        profile = fileManager.readFiles(fileName: FileNames.name, fileAboutMe: FileNames.aboutMe, fileImage: FileNames.image)
    }
}
