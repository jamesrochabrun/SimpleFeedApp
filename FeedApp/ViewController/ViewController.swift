//
//  ViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit
import MarvelClient
import Combine

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

public protocol ViewModelViewInjection: UIView {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

public protocol ViewModelCellInjection: UICollectionViewCell {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

public protocol ViewModelReusableViewInjection: UICollectionReusableView {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
}

public protocol SectionIdentifierViewModel {
    
    associatedtype SectionIdentifier: Hashable
  //  associatedtype SectionIdentifierReusableView: ViewModelReusableViewInjection
    associatedtype CellIdentifier: Hashable
    associatedtype CellType: ViewModelCellInjection
    
    var sectionIdentifier: SectionIdentifier { get }
 //   var sectionIdentifierReusableViewType: SectionIdentifierReusableView.Type { get }
    var cellIdentifiers: [CellIdentifier] { get }
    var cellIdentifierType: CellType.Type { get }
}

public struct GenericSectionIdentifierViewModel<SectionIdentifier: Hashable,
                                             //   ReusableView: ViewModelReusableViewInjection,
                                                CellIdentifier: Hashable,
                                                Cell: ViewModelCellInjection>: SectionIdentifierViewModel {
    
    public var sectionIdentifier: SectionIdentifier
   // public var sectionIdentifierReusableViewType: ReusableView.Type { ReusableView.self }
    public var cellIdentifiers: [CellIdentifier]
    public var cellIdentifierType: Cell.Type { Cell.self }
}


@available(iOS 13, *)
public final class DiffableCollectionView<ViewModel: SectionIdentifierViewModel>: BaseView, UICollectionViewDelegate {
    
    // MARK:- UI
    var collectionView: UICollectionView! // intentionally force unwrapped, we need this else is dev error.

    // MARK:- Type Aliases
    public typealias SectionViewModelIdentifier = ViewModel.SectionIdentifier
    public typealias CellViewModelIdentifier = ViewModel.CellIdentifier // represents an item in a section
    public typealias CellType = ViewModel.CellType
  
    public typealias HeaderFooterProvider = (UICollectionView, SectionViewModelIdentifier?, String, IndexPath) -> UICollectionReusableView
    public typealias DiffDataSource = UICollectionViewDiffableDataSource<SectionViewModelIdentifier, CellViewModelIdentifier>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionViewModelIdentifier, CellViewModelIdentifier>
    
    public typealias SelectedContentAtIndexPath = ((CellViewModelIdentifier, IndexPath) -> Void)
    var selectedContentAtIndexPath: SelectedContentAtIndexPath?
    
    // MARK:- Diffable Data Source
    private var dataSource: DiffDataSource?
    private var currentSnapshot: Snapshot?
        
    // MARK:- Life Cycle
    override func setupViews() {
        collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.register(CellType.self)
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
    public func applyInitialSnapshotWith(_ itemsPerSection: [ViewModel]) {
        currentSnapshot = Snapshot()
        guard var currentSnapshot = currentSnapshot else { return }
        currentSnapshot.appendSections(itemsPerSection.map { $0.sectionIdentifier })
        itemsPerSection.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0.sectionIdentifier) }
        dataSource?.apply(currentSnapshot)
    }
    
    // MARK:- UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        selectedContentAtIndexPath?(viewModel, indexPath)
    }
    
    public func assignHedearFooter(_ headerFooterProvider: @escaping HeaderFooterProvider)  {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            return headerFooterProvider(collectionView, sectionIdentifier, kind, indexPath)
        }
    }
}

extension NSDiffableDataSourceSnapshot {
    
    mutating func deleteItems(_ items: [ItemIdentifierType], at section: Int) {
        deleteItems(items)
        let sectionIdentifier = sectionIdentifiers[section]
        guard numberOfItems(inSection: sectionIdentifier) == 0 else { return }
        deleteSections([sectionIdentifier])
    }
}
