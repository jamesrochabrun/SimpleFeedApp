//
//  UserProfileViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

/**
  Represents the Models and ViewModels for the personal information of a user
 */

// MARK:- Protocol
/**
- Remark:- protocol to display a header and a secondary header in a certain UI
 - `VerticalLabelsStackView` expects a view model that conforms to `HeaderSubHeaderInfo`
*/
protocol HeaderSubHeaderInfo {
    var header: String { get }
    var subHeader: String { get }
}

/**
- Remark:- viewModel that displayes a single category  like: followers count, following count, or posts  count.
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
- Remark:- viewModel that displayes followers, following and posts in a stackview.
*/
struct UserDataStackViewModel {
    
    let photoDataInfo: UserDataViewModel
    let followersDataInfo: UserDataViewModel
    let followingDataInfo: UserDataViewModel
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

/**
 - Remark:- viewModel displayed in the user profiles page as a header.
 */
struct UserProfileViewModel {
    
    var userAvatarURL: String?
    var userAvatarPlaceholder: UIImage?
    let userDataStackViewModel: UserDataStackViewModel
    let profileDescription: UserProfileDescription
    
    static var stub: UserProfileViewModel {
        .init(userAvatarURL: "",
                             userAvatarPlaceholder: UIImage(named: "zizou"),
                             userDataStackViewModel: UserDataStackViewModel(photoDataInfo: UserDataViewModel(numberInfo: "100", sectionInfoTitle: "Photos"),
                                                                            followersDataInfo: UserDataViewModel(numberInfo: "250", sectionInfoTitle: "Followers"),
                                                                            followingDataInfo: UserDataViewModel(numberInfo: "300", sectionInfoTitle: "Following")),
                             profileDescription: UserProfileDescription(userName: "Zizou", userPersonalDescription: "✈️🇲🇽🇨🇱🇯🇵🇪🇸🇻🇬"))
    }
}
