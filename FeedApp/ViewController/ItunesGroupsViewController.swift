//
//  ItunesGroupsViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/20/21.
//

import UIKit

final class ItunesGroupsViewController: GenericFeedViewController<ItunesGroupsViewController.SectionModel, ItunesRemote> {
    
    class TitleView: BaseView, ContentReusable {
        
        func cleanAndReuse() {
            label.text = ""
        }
        
        lazy var label: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 30)
            return label
        }()
        
        override func setupViews() {
            addSubview(label)
            label.fillSuperview(withinSafeArea: true, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        }
    }

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
        
        collectionView.supplementaryViewProvider { collectionView, sectionModel, kind, indexPath in
            collectionView.registerHeader(CollectionReusableViewContainer<TitleView>.self, kind: kind)
            let header: CollectionReusableViewContainer<TitleView> = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
            header.configureContent {
                $0.fillSuperview()
                $0.label.text = sectionModel.rawValue
            }
            return header
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
