//
//  FeedItemHeaderView.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 4/4/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

struct HeaderPostViewModel {
    let user: UserProfileViewModel
    let location: String
}

final class FeedItemHeaderView: BaseXibView {
    
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: Label!
    @IBOutlet private var locationLabel: Label!
    @IBOutlet private var actionButton: UIButton! {
        didSet {
            actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        }
    }

    func setupWith(_ viewModel: HeaderPostViewModel) {
        usernameLabel?.text = viewModel.user.profileDescription.userName
        locationLabel?.text = viewModel.location
        profileImageView?.image = viewModel.user.userAvatar
    }
    
    @IBAction func actionButtonDidTapped(_ sender: UIButton) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView?.circle()
        profileImageView?.setupGradient(cornerRadius: profileImageView?.layer.cornerRadius ?? 0, lineWidth: 1.5)
    }
}

