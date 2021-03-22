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
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubviews()
    }
    
    /// To be overriden. Super does not need to be called.
    open func setupSubviews() {
    }
}
