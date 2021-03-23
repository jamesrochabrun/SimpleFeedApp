//
//  ProfileInfoView.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 3/29/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

final class ProfileInfoView: BaseXibView, ContentReusable {
    
    // MARK:- UI
    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            profileImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet private var profileDataView: ProfileDataView!
    @IBOutlet private var profileDescriptionStackView: VerticalLabelsStackView!
    @IBOutlet private var editProfileButton: Button! {
        didSet {
            editProfileButton.layer.borderWidth = 1.0
            editProfileButton.layer.cornerRadius = 4.0
            editProfileButton.layer.masksToBounds = false
            editProfileButton?.layer.borderColor = Theme.buttonTint.color?.cgColor
            editProfileButton?.setTitleColor(Theme.buttonTint.color, for: .normal)
            editProfileButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        }
    }
    
    // MARK:- Configuration
    func setupWith(_ viewModel: UserProfileViewModel) {
        profileImageView?.image = viewModel.userAvatarPlaceholder
        profileDataView?.setupWith(viewModel.userDataStackViewModel)
        profileDescriptionStackView?.setupWith(viewModel.profileDescription)
    }
    
    // MARK:- Handlers
    @IBAction func editProfileTapped(_ sender: UIButton) {
    }
    
    // MARK:- LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView?.circle()
        profileImageView?.setupGradient(cornerRadius: profileImageView?.layer.cornerRadius ?? 0)
    }
    
    func cleanAndReuse() {
        profileImageView?.image = nil
    }
}
