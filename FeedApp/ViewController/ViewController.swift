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

public protocol SectionIdentifierViewModel {
    associatedtype SectionIdentifier: Hashable
    associatedtype CellIdentifier: Hashable
    associatedtype CellType: CellViewModel
    
    var sectionIdentifier: SectionIdentifier { get }
    var cellIdentifiers: [CellIdentifier] { get }
    var cellIdentifierType: CellType.Type { get }
}

@available(iOS 13, *)
public final class DiffableCollectionView<ViewModel: SectionIdentifierViewModel>: BaseView, UICollectionViewDelegate {
    
    // MARK:- UI
    var collectionView: UICollectionView!

    // MARK:- Type Aliases
    public typealias CellViewModelIdentifier = ViewModel.CellIdentifier // represents an item in a section
    public typealias SectionViewModelIdentifier = ViewModel.SectionIdentifier
    public typealias HeaderFooter = CollectionReusableView
    public typealias CellType = ViewModel.CellType
  
    public typealias HeaderFooterProvider = (UICollectionView, SectionViewModelIdentifier?, String, IndexPath) -> HeaderFooter
    public typealias DiffDataSource = UICollectionViewDiffableDataSource<SectionViewModelIdentifier, CellViewModelIdentifier>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionViewModelIdentifier, CellViewModelIdentifier>
    
    public typealias SelectedContentAtIndexPath = ((CellViewModelIdentifier, IndexPath) -> Void)
    var selectedContentAtIndexPath: SelectedContentAtIndexPath?
    
    // MARK:- Diffable Data Source
    private var dataSource: DiffDataSource?
    private var currentSnapshot: Snapshot?
    
    private weak var parent: UIViewController?
    
    // MARK:- Life Cycle
    convenience public init(layout: UICollectionViewLayout, parent: UIViewController?) {
        self.init()
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CellType.self)
        collectionView?.registerHeader(HeaderFooter.self, kind: UICollectionView.elementKindSectionHeader)
        collectionView?.registerHeader(HeaderFooter.self, kind: UICollectionView.elementKindSectionFooter)
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.collectionViewLayout = layout
        configureDataSource()
        self.parent = parent
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
    public func applySnapshotWith(_ itemsPerSection: [ViewModel]) {
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

public final class CollectionReusableView: UICollectionReusableView {
    
    public typealias SearchHeaderCollection = DiffableCollectionView<GenericSectionIdentifierViewModel<SectionIdentifierExample, CharacterViewModel, ArtworkCell>>
    
    private lazy var searchHeaderCollectionView: SearchHeaderCollection = {
        SearchHeaderCollection(layout: HorizontalLayoutKind.horizontalStoryUserCoverLayout.layout, parent: nil)
    }()
    
    private var marvelProvider = MarvelProvider()
    
    private var cancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        addSubview(searchHeaderCollectionView)
        searchHeaderCollectionView.fillSuperview()
        marvelProvider.fetchCharacters()
        
        cancellable = marvelProvider.$characters.sink { [weak self] in
            self?.searchHeaderCollectionView.applySnapshotWith($0)
        }
    }
    public override func prepareForReuse() {
        super.prepareForReuse()
    //    cancellables.forEach { $0.cancel() }
    }
}



//public final class CollectionReusableView<T: UIView>: UICollectionReusableView {
//
//    typealias ContentConfiguration = (T) -> Void
//
//    private let content: T = {
//        T()
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    func initialize() {
//        addSubview(content)
//    }
//
//    func configureContent(_ configuration: ContentConfiguration) {
//        configuration(content)
//    }
//}
