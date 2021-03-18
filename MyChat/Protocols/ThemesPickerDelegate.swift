//
//  ThemesPickerDelegate.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 05.03.2021.
//

import UIKit

protocol ThemesPickerDelegate: class {
    func changeThemeWorkDelegate(theme: Theme) -> Theme
}
