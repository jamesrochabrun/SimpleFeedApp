//
//  DetailPageViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/25/21.
//

import UIKit

final class DetailPageViewController: UIViewController, Coordinating {
    
    weak var coordinator: DetailPageCoordinator?
    
    deinit {
        print("Dismissed")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissThis))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissThis() {
        
        dismiss(animated: true)
    }
}
