//
//  FileNames.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 20.03.2021.
//

import Foundation

protocol IFileNames {
    var name: String { get }
    var aboutMe: String { get }
    var image: String { get }
    var theme: String { get }
}

class FileNames: IFileNames {
    let name = "name.txt"
    let aboutMe = "aboutMe.txt"
    let image = "image.png"
    let theme = "theme.txt"
}
