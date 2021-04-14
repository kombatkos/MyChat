//
//  ThemeManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 08.03.2021.
//

import Foundation

/// Enum declaration
let themeKey = "SelectedTheme"

struct ThemesService {
    
    static func currentTheme() -> Theme {
        let fileManager = FilesManager()
        if let theme = fileManager.readThemeFile(fileName: FileNames.theme) {
            return theme
        } else {
            return .classic
        }
    }
    
    static func applyTheme(theme: Theme, completion: @escaping (Bool) -> Void) {
        let fileManager = FilesManager()
            do {
                try fileManager.writeThemeFile(theme: theme, fileName: FileNames.theme)
                completion(true)
            } catch let error {
                print(error.localizedDescription)
                completion(false)
            }
    }
    
//    static func currentTheme() -> Theme {
//        if let storedTheme = (UserDefaults.standard.value(forKey: themeKey) as AnyObject).integerValue {
//            return Theme(rawValue: storedTheme) ?? .classic
//        } else {
//            return .classic
//        }
//    }
//
//    static func applyTheme(theme: Theme) {
//        UserDefaults.standard.setValue(theme.rawValue, forKey: themeKey)
//        UserDefaults.standard.synchronize()
//    }
}
