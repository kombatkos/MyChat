//
//  PaletteProtocol.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 09.03.2021.
//

import UIKit

protocol PaletteProtocol {
    /// Label Color
    var labelColor: UIColor {get}
    
    /// Button Color
    var buttonColor: UIColor {get}
    
    /// Customizing the Navigation Bar
    var barStyle: UIBarStyle {get}
    
    /// Customizing the Keyboard
    var keyboardStyle: UIKeyboardAppearance {get}
    
    /// Customizing the ActivityIndicator
    var activityIndicatorStyle: UIActivityIndicatorView.Style {get}
    
    /// Customizing the Alert Controller
    var alertStyle: UIUserInterfaceStyle {get}

    /// BackgroundColor
    var backgroundColor: UIColor {get}
    
    /// BackgroundColor for ConversationVC bottom view
    var conversationBottomViewColor: UIColor {get}
    
    /// Customizing TextFiewld
    var placeHolderColor: UIColor {get}
    
    // TableView block:
    var tableViewSubtitleColor: UIColor {get}
    var tableViewHeaderFooterColor: UIColor {get}
    var cellSelectedView: UIView {get}
    
    // Themes picker block:
    var borderColorForClassic: UIColor {get}
    var borderColorForDay: UIColor {get}
    var borderColorForNight: UIColor {get}
    
    // Color for bubbles:
    var bubbleLeftColor: UIColor? {get}
    var bubbleRightColor: UIColor? {get}
    var rightBubbleLabelColor: UIColor {get}
}
