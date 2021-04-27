//
//  DetailPageViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/25/21.
//

import UIKit

final class DetailPageViewController: UIViewController, Coordinating {
    
    weak var coordinator: DetailPageCoordinator?
    var detailImage: UIImage?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    deinit {
        print("Dismissed")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissThis))
        view.addGestureRecognizer(tap)
        configurView()
    }
    
    private func configurView() {
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.image = detailImage
    }
    
    @objc
    func dismissThis() {
        dismiss(animated: true)
    }
}
