//
//  BaseView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        
    }
}
