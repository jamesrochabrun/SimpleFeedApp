//
//  SearchViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 4/7/21.
//

import UIKit
import Combine

final class SearchResultCell: CollectionViewCell, ViewModelCellConfiguration {
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
    
    // MARK:- ViewModelCellConfiguration
    func configureCell(with viewModel: ArtistViewModel) {
        titleLabel.text = viewModel.name
    }
}

final class SearchTitleHeader: BaseView, ViewModelViewConfiguration, ContentReusable {
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override func setupViews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
        titleLabel.backgroundColor = .orange
    }
    
    func configureView(with viewModel: String) {
        titleLabel.text = viewModel
    }
    
    func cleanAndReuse() {
        titleLabel.text = ""
    }
}

enum SearchViewControllerIdentifier: String {
    case main = "Main"
    case secondary = "Secondary"
}

final class SearchViewController: GenericFeedViewController<SearchViewController.SectionModel, ItunesRemote>  {
    
    typealias SectionModel = GenericSectionIdentifierViewModel<SearchViewControllerIdentifier, ArtistViewModel>
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Type something here to search"
        return searchController
    }()
    
    override func viewDidLoad() {
        remote.searchWithTerm("lil")

        super.viewDidLoad()
        navigationItem.searchController = searchController
    }
    
    override func setUpUI() {
        collectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as SearchResultCell
        }
        collectionView.supplementaryViewProvider { collectionView, model, kind, indexPath in
            guard let model = model else { return nil }
            collectionView.registerHeader(CollectionReusableViewContainer<SearchTitleHeader>.self, kind: kind)
            let header: CollectionReusableViewContainer<SearchTitleHeader> = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
            header.configureContent {
                $0.fillSuperview()
                $0.configureView(with: model.rawValue)
            }
            return header
        }
        collectionView.selectedContentAtIndexPath = { [weak self] viewModel, indexPath in
            guard let self = self else { return }
            self.collectionView.deleteItem(viewModel)
        }
    }
    
    override func updateUI() {
        remote.$artists.sink { [weak self] models in
            guard let self = self else { return }
            self.collectionView.content {
                let newModels = models.chunked(into: max(models.count, 2)  / 2)
                SectionModel(sectionIdentifier: .main, cellIdentifiers: newModels.first ?? [])
                SectionModel(sectionIdentifier: .secondary, cellIdentifiers: newModels.last ?? [])
            }
        }.store(in: &cancellables)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        // remote.searchWithTerm(query)
        collectionView.searchForKey(\.name) { text in
            text.hasSubstring(query)
        }
    }
}


