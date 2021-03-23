//
//  GenericSectionIdentifierViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import Foundation

/// Defines a Model for a Section in a Diffable DataSource, conforms to `SectionIdentifierViewModel`
/// Use this generic class instead of creating a specific object for a section.
final class GenericSectionIdentifierViewModel<SectionIdentifier: Hashable,
                                                CellIdentifier: Hashable,
                                                Cell: ViewModelCellInjection>: SectionIdentifierViewModel {
    
    /// The Hashable Section identifier in a Diffable CollectionView
    public var sectionIdentifier: SectionIdentifier
    /// The Hashable section items  in a Section in a  Diffable CollectionView
    public var cellIdentifiers: [CellIdentifier] = []
    /// The Cell Type in a Diffable CollectionView
    public var cellIdentifierType: Cell.Type { Cell.self }
    
    init(sectionIdentifier: SectionIdentifier, cellIdentifiers: [CellIdentifier] ) {
        self.sectionIdentifier = sectionIdentifier
        self.cellIdentifiers = cellIdentifiers
    }
}
