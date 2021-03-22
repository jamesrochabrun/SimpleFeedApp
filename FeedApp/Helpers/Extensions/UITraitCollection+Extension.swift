//
//  UITraitCollection+Extension.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

extension UITraitCollection {
    
    var isRegularWidth: Bool { horizontalSizeClass == .regular }
    var isRegularHeight: Bool { verticalSizeClass == .regular }
    var isRegularWidthRegularHeight: Bool { isRegularWidth && isRegularHeight }
    
    func isDifferentToPrevious(_ previousTraitCollection: UITraitCollection?) -> Bool {
        verticalSizeClass != previousTraitCollection?.verticalSizeClass || horizontalSizeClass != previousTraitCollection?.horizontalSizeClass
    }
}
