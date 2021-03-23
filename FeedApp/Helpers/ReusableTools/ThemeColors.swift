//
//  ThemeColors.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

/// Defines the color of the app for dark and light mode, this colors are located in the Colors Asset Catalog.
enum Theme: String {
    
    case primaryText
    case secondaryText
    case mainBackground
    case buttonTint
    case circularBorder
    
    var color: UIColor? {
        UIColor(named: self.rawValue)
    }
}
