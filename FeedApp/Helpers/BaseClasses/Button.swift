//
//  Button.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

final class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        tintColor = Theme.buttonTint.color
    }
}
