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
