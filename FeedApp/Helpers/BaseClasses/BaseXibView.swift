//
//  BaseXibView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

class BaseXibView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupXib()
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    /// To be overriden. Super does not need to be called.
    func setUpViews() {
    }
}

extension UIView {
    
    fileprivate func setupXib() {
        
        guard let view = self.loadView() else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(view)
    }
    
    private func loadView() -> UIView? {
        guard let nibName =  NSStringFromClass(type(of: self)).components(separatedBy: ".").last else {
            return nil
        }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
}
