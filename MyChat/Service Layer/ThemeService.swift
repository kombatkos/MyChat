//
//  ThemeManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 08.03.2021.
//

import Foundation

protocol IThemeService {
    func currentTheme() -> Theme
    func applyTheme(theme: Theme, completion: @escaping (Bool) -> Void)
}

class ThemeService: IThemeService {
    
    let fileNames: IFileNames
    let filesManager: IFilesManager
    
    init(fileNames: IFileNames, filesManager: IFilesManager) {
        self.fileNames = fileNames
        self.filesManager = filesManager
    }
    
    func currentTheme() -> Theme {
        let fileName = fileNames.theme
        if let theme = filesManager.readThemeFile(fileName: fileName) {
            return theme
        } else {
            return .classic
        }
    }
    
    func applyTheme(theme: Theme, completion: @escaping (Bool) -> Void) {
        let fileName = fileNames.theme
            do {
                try filesManager.writeThemeFile(theme: theme, fileName: fileName)
                completion(true)
            } catch let error {
                print(error.localizedDescription)
                completion(false)
            }
    }
}
