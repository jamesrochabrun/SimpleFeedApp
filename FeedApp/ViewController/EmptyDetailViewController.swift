//
//  EmptyDetailViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit

final class EmptyDetailViewController: ViewController {
    
    let textLabel: Label = {
        let label = Label()
        label.text = "Start Selecting an item from the left pannel"
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textLabel)
        textLabel.fillSuperview()
    }
}
