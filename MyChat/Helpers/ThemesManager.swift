//
//  ThemeManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 08.03.2021.
//

import UIKit
import Foundation

enum Theme: Int {
    
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
    
    // TableView block:
    var tableViewSubtitleColor: UIColor {
        return .gray
    }
    
    var tableViewHeaderFooterColor: UIColor {
        switch self {
        case .classic:
            return .lightGray
        case .day:
            return .lightGray
        case .night:
            return .darkGray
        }
    }
    
    var cellSelectedColor: UIColor {
        switch self {
        case .classic:
            return .lightGray
        case .day:
            return .lightGray
        case .night:
            return .darkGray
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
            return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
        case .day:
            return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
        case .night:
            return .darkGray
        }
    }
    
    var bubbleRightColor: UIColor? {
        switch self {
        case .classic:
            return UIColor(red: 221/255, green: 246/255, blue: 199/255, alpha: 1)
        case .day:
            return UIColor(red: 76/255, green: 140/255, blue: 246/255, alpha: 1)
        case .night:
            return .lightGray
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
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: themeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .classic
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: themeKey)
        UserDefaults.standard.synchronize()
    }
}