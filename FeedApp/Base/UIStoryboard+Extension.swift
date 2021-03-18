//
//  UIStoryboard+Extension.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import UIKit

extension UIViewController {
    static var defaultStoryboardName: String {
        return String(describing: self)
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: defaultStoryboardName, bundle: nil)
    }
}

extension UIStoryboard {

    func instantiateViewControllerSubclass<T: UIViewController>() -> T {
        // Force casting as it would be programmer error to use this function and create a view controller from a storyboard whos initial view controller is not of this type.
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }

    func instantiateInitialViewControllerSubclass<T: UIViewController>() -> T {
        // Force casting as it would be programmer error to use this function and create a view controller from a storyboard whos initial view controller is not of this type.
        return instantiateInitialViewController() as! T
    }
}

protocol Storyboardable: class {
    static var defaultStoryboardName: String { get }
}

extension Storyboardable where Self: UIViewController {

    static func storyboardInitialViewController() -> Self {
        // Force casting as it would be programmer error to use this function and create a view controller from a storyboard whos initial view controller is not of this type.
        return Self.storyboard.instantiateInitialViewControllerSubclass()
    }

    static func instantiate(from storyboard: UIStoryboard) -> Self {
        // Force casting as it would be programmer error to use this function and create a view controller from a storyboard whos initial view controller is not of this type.
        return storyboard.instantiateViewControllerSubclass()
    }
    
    /**
     Use the ViewController Class that you want to be returned as caller.
     Use the name of the Storyboard as parameter.
     This function should be used when the Storyboard name does not match the class name of it's Initial ViewController, Ideally they should.
     **/
    static func instantiate(from storyboardName: String) -> Self {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewControllerSubclass()
    }
}

extension UIViewController: Storyboardable { }


// SplitViewController


extension UISplitViewController {
    
    /// Return:- The master view controller.
    var primaryViewController: UIViewController? {
        viewControllers.first
    }
    /// Return:- The detail view controller.
    var secondaryViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers.last : nil
    }
    
    /// Convenience wrapper to display the detail embedded in a navigation controller if vc is not a navigation controller already.
    func showDetailInNavigationControllerIfNeeded(_ vc: UIViewController, sender: Any?) {
        let detail = vc is UINavigationController ? vc : NavigationController(rootViewController: vc)
        showDetailViewController(detail, sender: sender)
    }
    
    /// Convenience method to detect if a view controller is a detail, this helps to detect pushes in navigation stack if needed.
    func isDetail(_ viewController: UIViewController) -> Bool {
        (viewController.navigationController ?? viewController) == secondaryViewController
    }
}


extension UIButton {
    
    convenience init(image: UIImage? = nil, title: String? = nil, titleColor: UIColor? = nil, titleFont: UIFont? = nil) {
        self.init()
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = titleFont
    }
    
    convenience init(type: UIButton.ButtonType, image: UIImage?, target: Any, selector: Selector) {
        self.init(type: type)
        setImage(image, for: .normal)
        addTarget(target, action: selector, for: .touchUpInside)
    }
}


final class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        //tintColor = Theme.buttonTint.color
    }
}


enum Theme: String {
    
    case primaryText
    case secondaryText
    case mainBackground
    case buttonTint
    case circularBorder
    
    var color: UIColor? {
        UIColor(named: self.rawValue)
    }
}

extension UITraitCollection {
    
    var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }
    
    var isRegularHeight: Bool {
        verticalSizeClass == .regular
    }
    
    var isRegularWidthRegularHeight: Bool {
        isRegularWidth && isRegularHeight
    }
    
    func isDifferentToPrevious(_ previousTraitCollection: UITraitCollection?) -> Bool {
        verticalSizeClass != previousTraitCollection?.verticalSizeClass || horizontalSizeClass != previousTraitCollection?.horizontalSizeClass
    }
}
