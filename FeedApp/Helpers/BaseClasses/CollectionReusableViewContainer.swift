//
//  CollectionReusableViewContainer.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
        
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
    func setupSubviews() {
    }
}

final class CollectionReusableViewContainer<Content: ContentReusable>: CollectionReusableView {

    typealias ContentConfiguration = (Content) -> Void
    
    private let content: Content = {
        Content()
    }()
    
    override func setupSubviews() {
        addSubview(content)
    }
    
    func configureContent(_ configuration: ContentConfiguration) {
        configuration(content)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        content.cleanAndReuse()
    }
}
