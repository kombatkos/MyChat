//
//  LoadProfileOperation.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 12.04.2021.
//

import Foundation

class LoadProfileOperation: Operation {
    
    var fileManager: IFilesManager
    var fileNames: IFileNames
    var profile: Profile?
    
    init(fileManager: IFilesManager, fileNames: IFileNames) {
        self.fileNames = fileNames
        self.fileManager = fileManager
        super.init()
    }
    
    override func main() {
        profile = fileManager.readFiles(fileName: fileNames.name, fileAboutMe: fileNames.aboutMe, fileImage: fileNames.image)
    }
}
