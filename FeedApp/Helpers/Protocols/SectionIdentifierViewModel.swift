//
//  SectionIdentifierViewModel.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import Foundation

//class UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable

/// PAT that defines the dependencies in a Section in a Deiffable DataSource
protocol SectionIdentifierViewModel {
    
    associatedtype SectionIdentifier: Hashable
    associatedtype CellIdentifier: Hashable
    
    var sectionIdentifier: SectionIdentifier { get }
    var cellIdentifiers: [CellIdentifier] { get }
}

