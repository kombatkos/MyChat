//
//  ThemeManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 08.03.2021.
//

import UIKit
import Foundation

enum Theme: String, PaletteProtocol {
    
    case classic, day, night
    
    /// Label Color
    var labelColor: UIColor {
        switch self {
        case .classic:
            return .black
        case .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var placeHolderColor: UIColor {
        switch self {
        case .night:
            return UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        default:
            return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        }
    }
    
    /// Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .classic:
            return .default
        case .day:
            return .default
        case .night:
            return .blackTranslucent
        }
    }
    
    var keyboardStyle: UIKeyboardAppearance {
        switch self {
        case .night:
            return UIKeyboardAppearance.dark
        default:
            return UIKeyboardAppearance.light
        }
    }
    
    var activityIndicatorStyle: UIActivityIndicatorView.Style {
        switch self {
        case .night:
            return .white
        default:
            return .gray
        }
    }
    
    /// Customizing the Alert Controller
    var alertStyle: UIUserInterfaceStyle {
        switch self {
        case .classic:
            return .light
        case .day:
            return .light
        case .night:
            return .dark
        }
    }

    /// BackgroundColor
    var backgroundColor: UIColor {
        switch self {
        case .classic:
            return .white
        case .day:
            return .white
        case .night:
            return .black
        }
    }
    
    /// BackgroundColor for ConversationVC bottom view
    var conversationBottomViewColor: UIColor {
        switch self {
        case .night:
            return UIColor(red: 20/255, green: 21/255, blue: 20/255, alpha: 1)
        default:
            return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
    }
    
    // TableView block:
    var tableViewSubtitleColor: UIColor {
        return .gray
    }
    
    var tableViewHeaderFooterColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        case .day:
            return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        case .night:
            return UIColor(red: 18/255, green: 19/255, blue: 18/255, alpha: 1)
        }
    }
    
    var cellSelectedView: UIView {
        let classicViewTheme = UIView()
        classicViewTheme.backgroundColor = .lightGray
        let nightViewTheme = UIView()
        nightViewTheme.backgroundColor = .darkGray
        switch self {
        case .classic:
            return classicViewTheme
        case .day:
            return classicViewTheme
        case .night:
            return nightViewTheme
        }
    }
    
    // Themes picker block:
    var borderColorForClassic: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.13, green: 0.61, blue: 0.99, alpha: 1)
        default:
            return UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        }
    }
    
    var borderColorForDay: UIColor {
        switch self {
        case .day:
            return UIColor(red: 0.13, green: 0.61, blue: 0.99, alpha: 1)
        default:
            return UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        }
    }
    
    var borderColorForNight: UIColor {
        switch self {
        case .night:
            return UIColor(red: 0.13, green: 0.61, blue: 0.99, alpha: 1)
        default:
            return UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        }
    }
    
    // Color for bubbles:
    var bubbleLeftColor: UIColor? {
        switch self {
        case .classic:
            return UIColor(red: 0.91, green: 0.92, blue: 0.93, alpha: 1.00)
        case .day:
            return UIColor(red: 0.91, green: 0.92, blue: 0.93, alpha: 1.00)
        case .night:
            return UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        }
    }
    
    var bubbleRightColor: UIColor? {
        switch self {
        case .classic:
            return UIColor(red: 221/255, green: 246/255, blue: 199/255, alpha: 1)
        case .day:
            return UIColor(red: 76/255, green: 140/255, blue: 246/255, alpha: 1)
        case .night:
            return UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
        }
    }
    
    var rightBubbleLabelColor: UIColor {
        switch self {
        case .classic:
            return .black
        default:
            return .white
        }
    }

}

/// Enum declaration
let themeKey = "SelectedTheme"

struct ThemesManager {
    
    static let queue = DispatchQueue.global()
    
    static func currentTheme() -> Theme {
        let fileManager = FilesManager()
        if let theme = fileManager.readThemeFile(fileName: "theme.txt") {
            return theme
        } else {
            return .classic
        }
    }
    
    static func applyTheme(theme: Theme, completion: @escaping (Bool) -> ()) {
        let fileManager = FilesManager()
            do {
                try fileManager.writeThemeFile(theme: theme, fileName: "theme.txt")
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
