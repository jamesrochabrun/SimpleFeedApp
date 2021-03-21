//
//  Label.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/19/21.
//

import UIKit

enum LabelKind {
    case primary
    case secondary
}

extension LabelKind {
    
    var textColor: UIColor? {
        switch self {
        case .primary: return Theme.primaryText.color
        case .secondary: return Theme.secondaryText.color
        }
    }
}

final class Label: UILabel {
    
    var kind: LabelKind = .primary
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        textColor = kind.textColor
        font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
    }
}

