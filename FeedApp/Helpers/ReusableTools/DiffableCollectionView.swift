//
//  DiffableCollectionView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit


final class DiffableCollectionView<ViewModel: SectionIdentifierViewModel>: BaseView, UICollectionViewDelegate {
    
    // MARK:- UI
    private var collectionView: UICollectionView! // intentionally force unwrapped, we need this else is dev error.

    // MARK:- Type Aliases
    typealias SectionViewModelIdentifier = ViewModel.SectionIdentifier
    typealias CellViewModelIdentifier = ViewModel.CellIdentifier // represents an item in a section
    typealias CellType = ViewModel.CellType
  
    typealias HeaderFooterProvider = (UICollectionView, SectionViewModelIdentifier?, String, IndexPath) -> UICollectionReusableView
    typealias DiffDataSource = UICollectionViewDiffableDataSource<SectionViewModelIdentifier, CellViewModelIdentifier>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionViewModelIdentifier, CellViewModelIdentifier>
    
    typealias SelectedContentAtIndexPath = ((CellViewModelIdentifier, IndexPath) -> Void)
    var selectedContentAtIndexPath: SelectedContentAtIndexPath?
    
    // MARK:- Diffable Data Source
    private var dataSource: DiffDataSource?
    private var currentSnapshot: Snapshot?
    private var sectionItems: [ViewModel] = []
        
    // MARK:- Life Cycle
    override func setupViews() {
        backgroundColor = .clear
        collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.register(CellType.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.fillSuperview()
        configureDataSource()
    }
    
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView.collectionViewLayout = layout
        }
    }
    
    // MARK:- 1: DataSource Configuration
    private func configureDataSource() {
        dataSource = DiffDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cell: CellType = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.viewModel = model as? CellType.ViewModel
            return cell
        }
    }
    
    // MARK:- 2: ViewModels injection and snapshot
    func applyInitialSnapshotWith(_ sectionItems: [ViewModel], animated: Bool = false) {
        self.sectionItems = sectionItems
        currentSnapshot = Snapshot()
        guard var currentSnapshot = currentSnapshot else { return }
        currentSnapshot.appendSections(sectionItems.map { $0.sectionIdentifier })
        sectionItems.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0.sectionIdentifier) }
        dataSource?.apply(currentSnapshot, animatingDifferences: animated)
    }
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        selectedContentAtIndexPath?(viewModel, indexPath)
    }
    
    func assignHedearFooter(_ headerFooterProvider: @escaping HeaderFooterProvider)  {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            return headerFooterProvider(collectionView, sectionIdentifier, kind, indexPath)
        }
    }
    
    func dataSourceItems() -> [ViewModel] {
        sectionItems
    }
    
    func scrollTo(_ indexPath: IndexPath, animated: Bool = true) {
        guard animated else {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            return
        }
        UIView.transition(with: collectionView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                          })
    }
}
