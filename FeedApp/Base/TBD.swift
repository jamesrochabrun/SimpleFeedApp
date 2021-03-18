//
//  TBD.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/17/21.
//

import UIKit


@available(iOS 13, *)
public final class DiffCollection<ViewModel: SectionIdentifierViewModel,
                                     HeaderFooter: UIView>: BaseView {
   
   // MARK:- Private
   private (set)var collectionView: UICollectionView! // if not initilaized, lets crash. 🤷🏽‍♂️
   private typealias DiffDataSource = UICollectionViewDiffableDataSource<ViewModel.SectionIdentifier, ViewModel.CellIdentifier>
   private var dataSource: DiffDataSource?
   private typealias Snapshot = NSDiffableDataSourceSnapshot<ViewModel.SectionIdentifier, ViewModel.CellIdentifier>
   private var currentSnapshot: Snapshot?
   
   // MARK:- Public
   public typealias CellProvider = (ViewModel.CellIdentifier, IndexPath) -> UIView
   public typealias HeaderFooterProvider = (ViewModel.SectionIdentifier, String, IndexPath) -> HeaderFooter?
   public typealias SelectedContentAtIndexPath = ((ViewModel.CellIdentifier, IndexPath) -> Void)
   public var selectedContentAtIndexPath: SelectedContentAtIndexPath?
   
    // MARK:- Life Cycle
    convenience init(layout: UICollectionViewLayout,
                     collectionViewDelegate: UICollectionViewDelegate,
                     cellProvider: @escaping CellProvider,
                     _ headerFooterProvider: HeaderFooterProvider?) {
        self.init()
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(WrapperViewCell.self)
        collectionView.registerHeader(WrapperCollectionReusableView<HeaderFooter>.self, kind: UICollectionView.elementKindSectionHeader)
        collectionView.registerHeader(WrapperCollectionReusableView<HeaderFooter>.self, kind: UICollectionView.elementKindSectionFooter)
        collectionView.delegate = collectionViewDelegate
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        configureDataSource(cellProvider)
        if let headerFooterProvider = headerFooterProvider {
            assignHedearFooter(headerFooterProvider)
        }
    }
   
   // MARK:- DataSource Configuration
   private func configureDataSource(_ cellProvider: @escaping CellProvider) {
       
       dataSource = DiffDataSource(collectionView: collectionView) { collectionView, indexPath, model in
           let cell: WrapperViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
           let cellView = cellProvider(model, indexPath)
           cell.setupWith(cellView)
           return cell
       }
   }
   
   // MARK:- ViewModel injection and snapshot
   public func applySnapshotWith(_ itemsPerSection: [ViewModel]) {
       currentSnapshot = Snapshot()
       guard var currentSnapshot = currentSnapshot else { return }
       currentSnapshot.appendSections(itemsPerSection.map { $0.sectionIdentifier })
       itemsPerSection.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0.sectionIdentifier) }
       dataSource?.apply(currentSnapshot)
   }
   
   private func assignHedearFooter(_ headerFooterProvider: @escaping HeaderFooterProvider) {
       
       dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
           let header: WrapperCollectionReusableView<HeaderFooter> = collectionView.dequeueSuplementaryView(of: kind, at: indexPath)
           if let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section],
              let view = headerFooterProvider(sectionIdentifier, kind, indexPath) {
               header.setupWith(view)
           }
           return header
       }
   }
}

@available(iOS 13.0, *)
// MARK:- Helper
extension NSDiffableDataSourceSnapshot {
    
    mutating func deleteItems(_ items: [ItemIdentifierType], at section: Int) {
        
        deleteItems(items)
        let sectionIdentifier = sectionIdentifiers[section]
        guard numberOfItems(inSection: sectionIdentifier) == 0 else { return }
        deleteSections([sectionIdentifier])
    }
}


final public class WrapperViewCell: BaseCollectionViewCell<UIView> {
    
    private var contentCellView: UIView?

    public override func setupWith(_ viewModel: UIView) {
        contentView.addSubview(viewModel)
        contentCellView = viewModel
        viewModel.fillSuperview()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.removeFromSuperview()
        viewModel = nil
    }
}

final public class WrapperCollectionReusableView<Content: UIView>: UICollectionReusableView {

    private var contentReusableView: UIView?

    public func setupWith(_ view: UIView) {
        addSubview(view)
        view.fillSuperview()
        contentReusableView = view
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        contentReusableView?.removeFromSuperview()
        contentReusableView = nil
    }
}

open class BaseCollectionViewCell<V>: UICollectionViewCell {
        
    public var viewModel: V? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupWith(viewModel)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubviews()
    }
    
    // To be overriden. Super does not need to be called.
    open func setupSubviews() {
    }
    
    // To be overriden. Super does not need to be called.
    open func setupWith(_ viewModel: V) {
    }
    
    /// Swift UI
    open func setupWith(_ viewModel: V, parent: UIViewController?) {
        
    }
}



@objc extension UIView {
    
    @objc public func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    
    @objc public func fillSuperview(withinSafeArea: Bool = false, padding: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { return }
        
        let superviewTopAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let superviewLeadingAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
        let superviewTrailingAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
        let superviewBottomAnchor = withinSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor

        // Apple Doc: Typically, using this method is more efficient than activating each constraint individually.
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom)
        ])
        
    }
    
    @objc public func centerInSuperview(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        } else if let h = height {
            heightAnchor.constraint(equalTo: h).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        } else if let w = width {
            widthAnchor.constraint(equalTo: w).isActive = true
        }
    }
    
    @objc public func anchorSize(to view: UIView, multiplier: CGFloat = 1.0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    @objc public func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    @objc public func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

public protocol CollectionReusable {}

/// Disclaimer: From Apple UI engineer - its allow to force cast the cell in this method, if it fails its mostly another issue in the implementation.

/// MARK:- UITableView
public extension CollectionReusable where Self: UITableViewCell  {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CollectionReusable {}

public extension UITableView {
    
    /// Register Programatic Cell
    func register<T: UITableViewCell>(_ :T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register Xib cell
    func registerNib<T: UITableViewCell>(_ :T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Deques a cell using as identifier a string describing the cell class.
    /// Returns a non optional cell.
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
        return cell
    }
    
    func registerFooterOrHeader<T: UITableViewHeaderFooterView>(_ :T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNibFooterOrHeader<T: UITableViewHeaderFooterView>(_ : T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueHeaderOrFooter<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}


/// MARK:- UICollectionView
public extension CollectionReusable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    
    /// Register Programatic Cell
    func register<T: UICollectionViewCell>(_ :T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register Xib cell
    func registerNib<T: UICollectionViewCell>(_ :T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return cell
    }
    
    /// Register Programatic Header
    func registerHeader<T: UICollectionReusableView>(_ :T.Type, kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Register Xib Header
    func registerNibHeader<T: UICollectionReusableView>(_ : T.Type, kind: String, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
        
    }
    
    func dequeueSuplementaryView<T: UICollectionReusableView>(of kind: String, at indexPath: IndexPath) -> T {
        let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return supplementaryView
    }
}

/// MARK:- UICollectionView
public extension CollectionReusable where Self: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: CollectionReusable {}


/// MARK:- TableView
public extension CollectionReusable where Self: UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: CollectionReusable {}

open class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        
    }
}
