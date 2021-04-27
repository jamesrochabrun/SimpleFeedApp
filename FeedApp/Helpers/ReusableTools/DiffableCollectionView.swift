//
//  DiffableCollectionView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

final class DiffableCollectionView<SectionContentViewModel: SectionIdentifierViewModel>: UIView, UICollectionViewDelegate {
    
    // MARK:- UI
    private var collectionView: UICollectionView
    
    // MARK:- Type Aliases
    typealias SectionViewModelIdentifier = SectionContentViewModel.SectionIdentifier // represents a section in the data source
    typealias CellViewModelIdentifier = SectionContentViewModel.CellIdentifier // represents an item in a section
    
    typealias HeaderFooterProvider = (UICollectionView, SectionViewModelIdentifier, String, IndexPath) -> UICollectionReusableView?
    typealias CellProvider = (UICollectionView, IndexPath, CellViewModelIdentifier) -> UICollectionViewCell
    
    typealias DiffDataSource = UICollectionViewDiffableDataSource<SectionViewModelIdentifier, CellViewModelIdentifier>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionViewModelIdentifier, CellViewModelIdentifier>
    
    typealias SelectedContentAtIndexPath = ((CellViewModelIdentifier, IndexPath) -> Void)
    var selectedContentAtIndexPath: SelectedContentAtIndexPath?
    
    // MARK:- Diffable Data Source
    private var dataSource: DiffDataSource?
    private var currentSnapshot: Snapshot?
    
    // MARK:- Getters
    
    /// returns the identifiers of all of the sections in the snapshot.
    var dataSourceSectionIdentifiers: [SectionContentViewModel.SectionIdentifier] { dataSource?.snapshot().sectionIdentifiers ?? [] }
    
    /// returns the identifiers of all of the items in the snapshot.
    var dataSourceFlatCellIdentifiers: [SectionContentViewModel.CellIdentifier] { dataSource?.snapshot().itemIdentifiers ?? [] }
    
    // MARK:- Life Cycle
    required init?(coder aDecoder: NSCoder) {
        collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(coder: aDecoder)
    }

    private override init(frame: CGRect) {
        collectionView = .init(frame: frame, collectionViewLayout: overrideLayout)
        super.init(frame: frame)
    }
    
    convenience init(layout: UICollectionViewLayout) {
        self.init(frame: .zero)
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    // MARK:- Public
    var overrideLayout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView.collectionViewLayout = overrideLayout
        }
    }
    
    /// Source of the content that will be injected in cells and supplementary views.
    /// - parameter content: function builder that expects sections, for more go to `DiffableDataSourceBuilder` struct definition
    func content(@DiffableDataSourceBuilder<SectionContentViewModel> _ content: () -> [SectionContentViewModel]) {
        let sectionItems = content()
        currentSnapshot = Snapshot()
        guard var currentSnapshot = currentSnapshot else { return }
        currentSnapshot.appendSections(sectionItems.map { $0.sectionIdentifier })
        sectionItems.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0.sectionIdentifier) }
        self.currentSnapshot = currentSnapshot
        dataSource?.apply(currentSnapshot, animatingDifferences: false) /// For a more responsive effect we set the `animatingDifferences` to false when app loads content
    }
    
    /// Source of supplementary views that will be displayed in the `collectionView`
    /// - parameter HeaderFooterProvider: closure of type `(UICollectionView, SectionViewModelIdentifier?, String, IndexPath) -> UICollectionReusableView?`
    func supplementaryViewProvider(_ headerFooterProvider: @escaping HeaderFooterProvider)  {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            return headerFooterProvider(collectionView, sectionIdentifier, kind, indexPath)
        }
    }
    
    /// Source of cells that will be displayed in the `collectionView`
    /// - parameter cellProvider: closure of type `(UICollectionView, IndexPath, CellViewModelIdentifier) -> UICollectionViewCell`
    func cellProvider(_ cellProvider: @escaping CellProvider)  {
        dataSource = DiffDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cell = cellProvider(collectionView, indexPath, model)
            return cell
        }
    }
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        selectedContentAtIndexPath?(viewModel, indexPath)
    }
    
    // MARK:- Helpers
    
    /// Scrolls to a certain  `IndexPath`animated or not.
    /// - parameter indexPath: The indexPath to scroll to.
    /// - parameter animated: `Bool` if `true` the scrolling will be performed with `transitionCrossDissolve` animation with duration of `0.2`
    func scrollTo(_ indexPath: IndexPath, animated: Bool = true) {
        
        collectionView.layoutIfNeeded()
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

// MARK:- Data Source updates
extension DiffableCollectionView {
    
    /// Inserts sections in to the snapshot, after a defined section
    /// - parameter sections: The new sections to be inserted
    /// - parameter section: The section where new sections will be inserted after.
    func insertSections(_ sections: [SectionContentViewModel.SectionIdentifier], after section: SectionContentViewModel.SectionIdentifier) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.insertSections(sections, afterSection: section)
        // currentSnapshot = snapshot
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    /// Inserts sections in to the snapshot, before a defined section
    /// - parameter sections: The new sections to be inserted
    /// - parameter section: The section where new sections will be inserted before.
    func insertSections(_ sections: [SectionContentViewModel.SectionIdentifier], before section: SectionContentViewModel.SectionIdentifier) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.insertSections(sections, beforeSection: section)
     //   currentSnapshot = snapshot
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    /// Deletes a section identifier from the snapshot using its hash value
    /// - parameter sectionIdentifier: The section identifier of the section that will be deleted
    func deleteSection(_ sectionIdentifier: SectionContentViewModel.SectionIdentifier) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteSections([sectionIdentifier])
  //      currentSnapshot = snapshot
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    /// Deletes a cell identifier from the snapshot using its hash value
    /// - parameter item: The item identifier  that will be deleted
    func deleteItem(_ item: SectionContentViewModel.CellIdentifier) {
        guard var snapshot = dataSource?.snapshot()  else { return }
        snapshot.deleteItems([item])
        // When using filter actions we have to keep in sync 2 snapshots.
        // - One can be the new filtered snaphot
        // - The second is the `currentSnaphot`
        currentSnapshot?.deleteItems([item])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func insertItem(_ item: SectionContentViewModel.CellIdentifier, at section: SectionContentViewModel.SectionIdentifier) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems([item], toSection: section)
  //      currentSnapshot = snapshot
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension DiffableCollectionView {

    func searchForKeyPathValue<Value>(_ key: KeyPath<CellViewModelIdentifier, Value>, isIncluded: (Value) -> Bool)  {
       
        guard let localCurrentSnapshot = currentSnapshot else { return }
        var filteredSnapshot = Snapshot()
        filteredSnapshot.appendSections(localCurrentSnapshot.sectionIdentifiers)
        for sectionIdentifier in localCurrentSnapshot.sectionIdentifiers {
            let items = localCurrentSnapshot.itemIdentifiers(inSection: sectionIdentifier).filter {  isIncluded($0[keyPath: key]) }
            filteredSnapshot.appendItems(items, toSection: sectionIdentifier)
            // Remove the section to remove the header
            if items.isEmpty { filteredSnapshot.deleteSections([sectionIdentifier]) }
        }
        dataSource?.apply(filteredSnapshot, animatingDifferences: false)
    }
}
// MARK:- Function Builder
@_functionBuilder
struct DiffableDataSourceBuilder<Section: SectionIdentifierViewModel>   {
    static func buildBlock(_ sections: Section...) -> [Section] { sections }
    static func buildBlock(_ components: [Section]...) -> [Section] { components.flatMap { $0 } }
}

extension String {
    /// Returns `true` if this string contains the provided substring,
    /// or if the substring is empty. Otherwise, returns `false`.
    ///
    /// - Parameter substring: The substring to search for within
    ///   this string.
    func hasSubstring(_ substring: String) -> Bool {
        substring.isEmpty || contains(substring)
    }
}
