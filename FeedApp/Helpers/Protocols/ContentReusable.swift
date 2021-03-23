//
//  ContentReusable.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import UIKit

/// UIVIew Constrain protocol that allows a certain sub view in a cell reuse its content
/// Call this in `prepareForReuse` of your cell
/*
 e.g:
 func prepareForReuse() {
    super.prepareForReuse()
    yourCustomViewSubViewOfThisCell.cleanAndReuse()
 }
 */
protocol ContentReusable: UIView {
    func cleanAndReuse()
}
