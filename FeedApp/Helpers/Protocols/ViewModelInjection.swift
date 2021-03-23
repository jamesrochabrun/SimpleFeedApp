//
//  ViewModelViewInjection.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

/// PAT that allows inject a certain view model to a UIVIew
protocol ViewModelViewInjection: UIView {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

/// PAT that allows inject a certain view model to a UICollectionViewCell
protocol ViewModelCellInjection: UICollectionViewCell {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

/// PAT that allows inject a certain view model to a UICollectionReusableView
protocol ViewModelReusableViewInjection: UICollectionReusableView {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}
