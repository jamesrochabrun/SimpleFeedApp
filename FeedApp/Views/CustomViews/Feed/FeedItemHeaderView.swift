//
//  FeedItemHeaderView.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 4/4/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

enum HorizontalFeedItemViewModelKind {
    case list
    case header
}

struct HorizontalFeedItemViewModel: IdentifiableHashable {
    let id = UUID()
    let user: UserProfileViewModel
    let location: String?
    let kind: HorizontalFeedItemViewModelKind
}

extension HorizontalFeedItemViewModel: Artwork {
    var imageURL: String { user.userAvatarURL ?? "" }
    var thumbnailURL: String { "" }
}

final class FeedItemHeaderView: BaseXibView, ContentReusable {
        
    @IBOutlet private var profileImageView: ImageViewLoader!
    @IBOutlet private var usernameLabel: Label!
    @IBOutlet private var actionButton: Button! {
        didSet {
            actionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        }
    }
    
    private var itemKind: HorizontalFeedItemViewModelKind = .list {
        didSet {
            actionButton?.alpha = itemKind == .list ? 0 : 1
        }
    }

    func setupWith(_ viewModel: HorizontalFeedItemViewModel) {
        usernameLabel?.text = viewModel.user.profileDescription.userName
        profileImageView?.load(regularURL: viewModel.imageURL, lowResURL: viewModel.thumbnailURL, placeholder: viewModel.user.userAvatarPlaceholder)
        itemKind = viewModel.kind
    }
    
    @IBAction func actionButtonDidTapped(_ sender: UIButton) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView?.circle()
        switch itemKind {
        case .header:
            profileImageView?.addBorder(Theme.circularBorder.color ?? .white, width: 2.0)
        case .list:
            profileImageView?.setupGradient(cornerRadius: profileImageView?.layer.cornerRadius ?? 0, lineWidth: 2.0)
        }
    }
    
    func cleanAndReuse() {
        usernameLabel?.text = ""
        actionButton?.alpha = 1
    }
}

