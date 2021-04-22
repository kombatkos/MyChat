//
//  SaveProfileOperation.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.04.2021.
//

import Foundation

class SaveProfileOperation: Operation {
    var saved = false
    var profile: Profile
    var fileManager: IFilesManager
    var fileNames: IFileNames
    
    init(profile: Profile, fileManager: IFilesManager, fileNames: IFileNames) {
        self.fileNames = fileNames
        self.profile = profile
        self.fileManager = fileManager
        super.init()
    }
    override func main() {
        do {
            try fileManager.writeFiles(profile: profile, fileName: fileNames.name,
                                       fileAboutMe: fileNames.aboutMe, fileImage: fileNames.image)
            self.saved = true
        } catch {
            self.saved = false
        }
    }
}
