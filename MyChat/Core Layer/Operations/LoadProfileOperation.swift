//
//  LoadProfileOperation.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.04.2021.
//

import Foundation

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
