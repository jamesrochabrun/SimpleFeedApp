//
//  CollectionViewCell.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        setupSubviews()
    }
    
    private func initialize() {
        backgroundColor = .clear
    }
    
    /// To be overriden. Super does not need to be called.
    open func setupSubviews() {
    }
}
