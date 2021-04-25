//
//  Coordinator.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/23/21.
//

import UIKit

protocol Coordinator: AnyObject {
    var topViewController: UIViewController? { get }
    var children: [Coordinator] { get set }
    var rootViewController: UINavigationController { get set }
    func start()
    init(rootViewController: UINavigationController)
}

extension Coordinator {
    var topViewController: UIViewController? { rootViewController.topViewController }
}

protocol Coordinating {
    associatedtype CoordinatingType: Coordinator
    var coordinator: CoordinatingType? { get set }
}
