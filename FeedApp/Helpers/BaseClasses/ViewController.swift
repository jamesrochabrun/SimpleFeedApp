//
//  ViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit
import MarvelClient
import Combine

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.mainBackground.color
        setUpNavigationItems()
    }
    
    private func setUpNavigationItems() {
        let notificationsBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(displayNotifications))
        notificationsBarButtonItem.tintColor = Theme.buttonTint.color
        navigationItem.rightBarButtonItem = notificationsBarButtonItem
    }
    
    // MARK:- Actions
    @objc func displayNotifications() {
        let notificationsViewController = NotificationsViewController(layout: UICollectionViewCompositionalLayout.notificationsList(header: false))
        navigationController?.present(notificationsViewController, animated: true)
    }
}

