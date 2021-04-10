//
//  MarvelFeedViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/2/21.
//

import UIKit
import Combine
import MarvelClient

enum MarvelFeedIdentifier {
    case awesome
}

final class MarvelFeedViewcontroller: GenericFeedViewController<MarvelFeedViewcontroller.SectionModel, MarvelRemote>  {
    
    typealias SectionModel = GenericSectionIdentifierViewModel<MarvelFeedIdentifier, SerieViewModel>

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchData() {
        remote.fetchSeries()
    }
    
    override func setUpUI() {
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as ArtworkCell
        }
    }
    
    override func updateUI() {
         remote.$serieViewModels.sink { [weak self] models in
             guard let self = self else { return }
             self.collectionView.content {
                 SectionModel(sectionIdentifier: .awesome, cellIdentifiers: models)
             }
         }.store(in: &cancellables)
     }
}
