//
//  ProfileInfoView.swift
//  SplitViewControllerTutorial
//
//  Created by james rochabrun on 3/29/20.
//  Copyright © 2020 james rochabrun. All rights reserved.
//

import UIKit

/**
- Remark:- viewModel displayes a single category  followers, following, posts or  counts.
*/
struct UserDataViewModel {
    
    let numberInfo: String
    let sectionInfoTitle: String
}

extension UserDataViewModel: HeaderSubHeaderInfo {
    var header: String { numberInfo }
    var subHeader: String { sectionInfoTitle }
}

/**
- Remark:- viewModel displayes followers, following and posts in a stackview.
*/
struct UserDataStackViewModel {
    
    let photoDataInfo: UserDataViewModel
    let followersDataInfo: UserDataViewModel
    let followingDataInfo: UserDataViewModel
}


// MARK:- Protocol
/**
- Remark:- protocol that allows UI reusability.
*/
protocol HeaderSubHeaderInfo {
    var header: String { get }
    var subHeader: String { get }
}

/**
 - Remark:- viewModel displayed in the user profiles page.
 */
struct UserProfileViewModel {
    
    var userAvatar: UIImage?
    let userDataStackViewModel: UserDataStackViewModel
    let profileDescription: UserProfileDescription
    
    static var stub: UserProfileViewModel {
        UserProfileViewModel(userAvatar: UIImage(named: "zizou"),
        userDataStackViewModel: UserDataStackViewModel(photoDataInfo: UserDataViewModel(numberInfo: "100", sectionInfoTitle: "Photos"),
                                                       followersDataInfo: UserDataViewModel(numberInfo: "250", sectionInfoTitle: "Followers"),
                                                       followingDataInfo: UserDataViewModel(numberInfo: "300", sectionInfoTitle: "Following")),
        profileDescription: UserProfileDescription(userName: "Zizou", userPersonalDescription: "✈️🇲🇽🇨🇱🇯🇵🇪🇸🇻🇬"))
    }
}

/**
- Remark:- viewModel  user name and personal description
*/
struct UserProfileDescription {
    let userName: String
    let userPersonalDescription: String
}

extension UserProfileDescription: HeaderSubHeaderInfo {
    
    var header: String { userName }
    var subHeader: String { userPersonalDescription }
}


final class ProfileInfoView: BaseXibView, ContentReusable {
    
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
    
    override func setUpViews() {
        super.setUpViews()
    }
    
    func setupWith(_ viewModel: UserProfileViewModel) {
        profileImageView.image = viewModel.userAvatar
        profileDataView.setupWith(viewModel.userDataStackViewModel)
        profileDescriptionStackView.setupWith(viewModel.profileDescription)
    }
    
    @IBAction func editProfileTapped(_ sender: UIButton) {
        print("profile edit tapped")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView?.circle()
        profileImageView?.setupGradient(cornerRadius: profileImageView?.layer.cornerRadius ?? 0)
    }
    
    func cleanAndReuse() {
    }
}
