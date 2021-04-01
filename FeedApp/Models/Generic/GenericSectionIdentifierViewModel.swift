//
//  GenericSectionIdentifierViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

/// Defines a Model for a Section in a Diffable DataSource, conforms to `SectionIdentifierViewModel`
/// Use this generic class instead of creating a specific object for a section.
struct GenericSectionIdentifierViewModel<SectionIdentifier: Hashable, CellIdentifier: Hashable>: SectionIdentifierViewModel {
    /// The Hashable Section identifier in a Diffable CollectionView
    public let sectionIdentifier: SectionIdentifier
    /// The Hashable section items  in a Section in a  Diffable CollectionView
    public var cellIdentifiers: [CellIdentifier]
}
