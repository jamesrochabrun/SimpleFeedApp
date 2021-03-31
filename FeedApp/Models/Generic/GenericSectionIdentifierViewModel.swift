//
//  GenericSectionIdentifierViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

/// Defines a Model for a Section in a Diffable DataSource, conforms to `SectionIdentifierViewModel`
/// Use this generic class instead of creating a specific object for a section.
struct GenericSectionIdentifierViewModel<SectionIdentifier: Hashable,
                                         CellIdentifier: Hashable>: SectionIdentifierViewModel {
    let id = UUID()
    
    /// The Hashable Section identifier in a Diffable CollectionView
    public let sectionIdentifier: SectionIdentifier
    /// The Hashable section items  in a Section in a  Diffable CollectionView
    public var cellIdentifiers: [CellIdentifier]
}

//
//class GenericSectionIdentifierViewModel<SectionIdentifier: Hashable,
//                                        CellIdentifier: Hashable>: SectionIdentifierViewModel {
//
//
//    let identifier = UUID()
//
//    /// The Hashable Section identifier in a Diffable CollectionView
//    public let sectionIdentifier: SectionIdentifier
//    /// The Hashable section items  in a Section in a  Diffable CollectionView
//    public var cellIdentifiers: [CellIdentifier]
//
//    init(sectionIdentifier: SectionIdentifier, cellIdentifiers: [CellIdentifier]) {
//        self.sectionIdentifier = sectionIdentifier
//        self.cellIdentifiers = cellIdentifiers
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//    }
//
//    static func == (lhs: GenericSectionIdentifierViewModel<SectionIdentifier, CellIdentifier>, rhs: GenericSectionIdentifierViewModel<SectionIdentifier, CellIdentifier>) -> Bool {
//        lhs.identifier == rhs.identifier
//    }
//}
