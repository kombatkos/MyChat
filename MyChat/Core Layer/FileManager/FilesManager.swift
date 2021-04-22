//
//  FilesManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.03.2021.
//

import UIKit

protocol IFilesManager {
    func writeFiles(profile: Profile, fileName: String, fileAboutMe: String, fileImage: String) throws
    func readFiles(fileName: String, fileAboutMe: String, fileImage: String) -> Profile?
    func readThemeFile(fileName: String) -> Theme?
    func writeThemeFile(theme: Theme, fileName: String) throws
}

class FilesManager: IFilesManager {
    
    let fileManager = FileManager.default
    
    func writeFiles(profile: Profile, fileName: String, fileAboutMe: String, fileImage: String) throws {
        let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())

        var url = temporaryDirectory.appendingPathComponent(fileName)
        let name = try? String(contentsOf: url, encoding: .utf8)
        if name != profile.name {
            try profile.name?.write(to: url, atomically: true, encoding: .utf8)
        }
        
        url = temporaryDirectory.appendingPathComponent(fileAboutMe)
        let aboutMe = try? String(contentsOf: url, encoding: .utf8)
        if aboutMe != profile.aboutMe {
            try profile.aboutMe?.write(to: url, atomically: true, encoding: .utf8)
        }
        
        url = temporaryDirectory.appendingPathComponent(fileImage)
        if let image = profile.avatarImage {
            try image.pngData()?.write(to: url, options: .atomic)
        }
    }
    
    func readFiles(fileName: String, fileAboutMe: String, fileImage: String) -> Profile? {
        let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        
        var url = temporaryDirectory.appendingPathComponent(fileName)
        let name = try? String(contentsOf: url, encoding: .utf8)
        
        url = temporaryDirectory.appendingPathComponent(fileAboutMe)
        let aboutMe = try? String(contentsOf: url, encoding: .utf8)
        
        var image: UIImage?
        url = temporaryDirectory.appendingPathComponent(fileImage)
        if fileManager.fileExists(atPath: url.path) {
            image = UIImage(contentsOfFile: url.path)
        }
        return Profile(name: name, aboutMe: aboutMe, avatarImage: image)
    }
    
    func readThemeFile(fileName: String) -> Theme? {
        let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let url = temporaryDirectory.appendingPathComponent(fileName)
        let theme = (try? String(contentsOf: url, encoding: .utf8)) ?? "classic"
        return Theme(rawValue: theme)
    }
    
    func writeThemeFile(theme: Theme, fileName: String) throws {
        let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let url = temporaryDirectory.appendingPathComponent(fileName)
        try theme.rawValue.write(to: url, atomically: true, encoding: .utf8)
    }
}
