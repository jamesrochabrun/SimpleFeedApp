//
//  VerticalLabelsStackView.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 3/29/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

final class VerticalLabelsStackView: BaseXibView, ContentReusable {
    
    // MARK:- UI
    @IBOutlet private var topLabel: Label! {
        didSet {
            topLabel.kind = .primary
        }
    }
    @IBOutlet private var bottomLabel: Label! {
        didSet {
            bottomLabel.kind = .primary
        }
    }
    
    // MARK:- Configuration
    func setupWith(_ item: HeaderSubHeaderInfo) {
        topLabel?.text = item.header
        bottomLabel?.text = item.subHeader
    }
    
    // MARK:- LifeCycle
    func cleanAndReuse() {
        [topLabel, bottomLabel].forEach { $0?.text = "" }
    }
}
