//
//  DiffableCollectionView.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import UIKit

protocol SectionIdentifier: AnyObject, IdentifiableHashable {
    
 //   associatedtype SectionIdentifier: Hashable
    associatedtype CellIdentifier: Hashable
    associatedtype CellType: ViewModelCellInjection
    
  //  var sectionIdentifier: SectionIdentifier { get }
    var cellIdentifiers: [CellIdentifier] { get }
    var cellIdentifierType: CellType.Type { get }
}


protocol DataSource {
    associatedtype Section: SectionIdentifier
    associatedtype Collection: Swift.Collection where Collection.Element == Section
    var sections: (Int) -> Collection { get set }
}


final class DiffCollection: BaseView, UICollectionViewDelegate {

    
    private var collectionView: UICollectionView! // intentionally force unwrapped, we need this else is dev error.
    
    override func setupViews() {
        backgroundColor = .clear
        collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        
     //   collectionView?.register(CellType.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.fillSuperview()
      //  configureDataSource()
    }
    
}


final class DiffableCollectionView<ViewModel: SectionIdentifierViewModel>: BaseView, UICollectionViewDelegate {
    
    // MARK:- UI
    private var collectionView: UICollectionView! // intentionally force unwrapped, we need this else is dev error.

    // MARK:- Type Aliases
    typealias SectionViewModelIdentifier = ViewModel//.SectionIdentifier
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
       // collectionView?.register(CellType.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.fillSuperview()
        configureDataSource()
    }
    
    var viewModels: [ViewModel] = []
    
    var layout: UICollectionViewLayout = UICollectionViewFlowLayout() {
        didSet {
            collectionView.collectionViewLayout = layout
        }
    }
    


    
    // MARK:- 1: DataSource Configuration
    private func configureDataSource() {
        dataSource = DiffDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            
//            if !self.sectionItems.isEmpty {
//                let id = self.sectionItems[indexPath.section].cellIdentifierType
//
//                print("zizou cell \(String(describing: id))")
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: id), for: indexPath)
//                cell.backgroundColor = .yellow
//
//             //   let cell: CellType = collectionView.dequeueReusableCell(forIndexPath: indexPath)
//              //  cell.viewModel = model as? CellType.ViewModel
//                return cell
//            }
            
               let cell: CellType = collectionView.dequeueReusableCell(forIndexPath: indexPath)
               cell.viewModel = model as? CellType.ViewModel
            return cell
          
        }
    }
    
    // MARK:- 2: ViewModels injection and snapshot
    func applyInitialSnapshotWith(_ sectionItems: [ViewModel], animated: Bool = false) {
        
        sectionItems.forEach { collectionView.register($0.cellIdentifierType) }
        self.sectionItems = sectionItems
        currentSnapshot = Snapshot()
        guard var currentSnapshot = currentSnapshot else { return }
        currentSnapshot.appendSections(sectionItems)
        sectionItems.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0) }
        dataSource?.apply(currentSnapshot, animatingDifferences: animated)
    }
    
    func body(@DiffableDataSourceBuilder<ViewModel> _ content: () -> [ViewModel]) {
        sectionItems = content()
        sectionItems.forEach { collectionView.register($0.cellIdentifierType) }
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
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                          })
    }
}




@_functionBuilder
struct DiffableDataSourceBuilder<Section: SectionIdentifierViewModel>   {
    static func buildBlock(_ sections: Section...) -> [Section] { sections }
}
