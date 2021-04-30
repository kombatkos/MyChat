//
//  OperationProfileService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.03.2021.
//

import Foundation

protocol ISaveProfileService: class {
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> Void)
    func loadProfile(completion: @escaping (Profile?) -> Void)
    func cancel()
}

class SaveProfileService: ISaveProfileService {
    
    let fileManager: IFilesManager
    let fileNames: IFileNames
    let queue = OperationQueue()
    
    init(fileManager: IFilesManager, fileNames: IFileNames) {
        self.fileNames = fileNames
        self.fileManager = fileManager
    }
    
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> Void) {
        
        let saveOperation = SaveProfileOperation(profile: profile, fileManager: fileManager, fileNames: fileNames)
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(saveOperation.saved)
            }
        }
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        queue.addOperation(saveOperation)
    }
    
    func loadProfile(completion: @escaping (Profile?) -> Void) {
        let loadOperation = LoadProfileOperation(fileManager: fileManager, fileNames: fileNames)
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
