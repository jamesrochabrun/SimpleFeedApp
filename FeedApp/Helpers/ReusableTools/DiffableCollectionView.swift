//
//  DiffableCollectionView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit


final class DiffableCollectionView<SectionContentViewModel: SectionIdentifierViewModel>: BaseView, UICollectionViewDelegate {
    
    // MARK:- UI
    private var collectionView: UICollectionView! // intentionally force unwrapped, we need this else is dev error.

    // MARK:- Type Aliases
    typealias SectionViewModelIdentifier = SectionContentViewModel
    typealias CellViewModelIdentifier = SectionContentViewModel.CellIdentifier // represents an item in a section
  
    typealias HeaderFooterProvider = (UICollectionView, SectionViewModelIdentifier.SectionIdentifier?, String, IndexPath) -> UICollectionReusableView
    typealias CellProvider = (UICollectionView, IndexPath, SectionViewModelIdentifier.CellIdentifier) -> UICollectionViewCell

    typealias DiffDataSource = UICollectionViewDiffableDataSource<SectionViewModelIdentifier, CellViewModelIdentifier>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionViewModelIdentifier, CellViewModelIdentifier>
    
    typealias SelectedContentAtIndexPath = ((CellViewModelIdentifier, IndexPath) -> Void)
    var selectedContentAtIndexPath: SelectedContentAtIndexPath?
    
    // MARK:- Diffable Data Source
    private var dataSource: DiffDataSource?
    private var currentSnapshot: Snapshot?
    private var sectionItems: [SectionContentViewModel] = []
        
    // MARK:- Life Cycle
    override func setupViews() {
        backgroundColor = .clear
        collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
        
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView.collectionViewLayout = layout
        }
    }

//    // MARK:- 2: ViewModels injection and snapshot
//    func applyInitialSnapshotWith(_ sectionItems: [SectionContentViewModel], animated: Bool = false) {
//        
//     //   sectionItems.forEach { collectionView.register($0.cellIdentifierType) }
//        self.sectionItems = sectionItems
//        currentSnapshot = Snapshot()
//        guard var currentSnapshot = currentSnapshot else { return }
//        currentSnapshot.appendSections(sectionItems)
//        sectionItems.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0) }
//        dataSource?.apply(currentSnapshot, animatingDifferences: animated)
//    }
    
    func content(@DiffableDataSourceBuilder<SectionContentViewModel> _ content: () -> [SectionContentViewModel]) {
        let sectionItems = content()
        currentSnapshot = Snapshot()
        guard var currentSnapshot = currentSnapshot else { return }
        currentSnapshot.appendSections(sectionItems)
        sectionItems.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0) }
        dataSource?.apply(currentSnapshot, animatingDifferences: false)
    }
    
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        selectedContentAtIndexPath?(viewModel, indexPath)
    }
    
    func supplementaryViewProvider(_ headerFooterProvider: @escaping HeaderFooterProvider)  {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            return headerFooterProvider(collectionView, sectionIdentifier?.sectionIdentifier, kind, indexPath)
        }
    }
    
    
    func cellProvider(_ cellProvider: @escaping CellProvider)  {
        dataSource = DiffDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cell = cellProvider(collectionView, indexPath, model)
            return cell
        }
    }
    
    
    var dataSourceSectionIdentifiers: [SectionContentViewModel] { dataSource?.snapshot().sectionIdentifiers ?? [] }
    
    func scrollTo(_ indexPath: IndexPath, animated: Bool = true) {
        guard animated else {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            return
        }
        UIView.transition(with: collectionView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                          })
    }
}




@resultBuilder
struct DiffableDataSourceBuilder<Section: SectionIdentifierViewModel>   {
    static func buildBlock(_ sections: Section...) -> [Section] { sections }
}
