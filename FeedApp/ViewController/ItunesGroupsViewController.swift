//
//  ItunesGroupsViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/20/21.
//

import Foundation

final class ItunesGroupsViewController: GenericFeedViewController<ItunesGroupsViewController.SectionModel, ItunesRemote> {
    
    typealias SectionModel = GenericSectionIdentifierViewModel<ItuneGroup, FeedItemViewModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.getAppGroups(ItuneGroup.allCases)
    }
    
    override func setUpUI() {
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
    }
    
    override func updateUI() {
        remote.$groups.sink { groups in
            self.collectionView.content {
                groups
            }
        }.store(in: &cancellables)
    }
}
