//
//  ViewModelViewInjection.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

/// PAT that allows inject a certain view model to a UIVIew
protocol ViewModelViewConfiguration: UIView {
    associatedtype ViewModel
    func configureView(with viewModel: ViewModel)
}

/// PAT that allows inject a certain view model to a UICollectionViewCell
protocol ViewModelCellConfiguration: UICollectionViewCell {
    associatedtype ViewModel
    func configureCell(with viewModel: ViewModel)
}

/// PAT that allows inject a certain view model to a UICollectionReusableView
protocol ViewModelReusableViewConfiguration: UICollectionReusableView {
    associatedtype ViewModel
    func configureSupplementaryView(with viewModel: ViewModel)
}
