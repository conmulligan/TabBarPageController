//
//  TabBarPageController.swift
//  TabBarPageController
//
//  Created by Conor Mulligan on 23/04/2018.
//  Copyright © 2018 Conor Mulligan.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// A container view controller that manages navigation between tabs of content.
/// Each tab is managed by a child view controller embedded in a `UIPageViewController` instance,
/// allowing users to navigate between tabs by selecting the tab bar item or swiping left and right.
open class TabBarPageController: UIViewController {
    
    /// An struct of configuration variables.
    internal struct Config {
        static let PageSpacing: CGFloat = 10
        static let VerticalHeight: CGFloat = 50
        static let HorizontalHeight: CGFloat = 34
        static let AnimationDuration: Double = 0.2
    }
    
    /// The page controller instance.
    open lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: [UIPageViewControllerOptionInterPageSpacingKey: Config.PageSpacing])
        viewController.dataSource = self
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    /// The tab bar.
    open lazy var tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    /// The tab bar's height constraint.
    internal var tabBarHeightConstraint: NSLayoutConstraint?
    
    /// The tab bar's bottom layout constraint.
    internal var tabBarBottomConstraint: NSLayoutConstraint?
    
    /// A list of view controllers, each of which is represented by a tab.
    internal var viewControllers = [UIViewController]()
    
    // MARK: - View Lifecycle
    
    override open func loadView() {
        super.loadView()
        
        /// Add the page view controller.
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.pageViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.pageViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        /// Add the tab bar.
        self.view.addSubview(self.tabBar)
        self.tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.tabBarHeightConstraint = self.tabBar.heightAnchor.constraint(equalToConstant: Config.VerticalHeight)
        self.tabBarHeightConstraint?.isActive = true
        
        self.tabBarBottomConstraint = self.tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.tabBarBottomConstraint?.isActive = true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutFor(traitCollection: self.traitCollection)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        self.layoutFor(traitCollection: newCollection)
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for viewController in self.viewControllers {
            self.updateContentInset(viewController: viewController)
        }
    }
    
    open override func viewDidLayoutSubviews() {
        self.layoutFor(traitCollection: self.view.traitCollection)
    }
    
    /// Updates the view constraints based on the supplied trait collection.
    ///
    /// - parameter traitCollection: The current trait collection.
    private func layoutFor(traitCollection: UITraitCollection) {
        var height: CGFloat = 0
        
        if traitCollection.verticalSizeClass == .compact {
            height = Config.HorizontalHeight
        } else {
            height = Config.VerticalHeight
        }
        
        if #available(iOS 11.0, *) {
            height = height + self.view.safeAreaInsets.bottom
        }
        
        self.tabBarHeightConstraint?.constant = height
    }
    
    // MARK: - Child View Controllers
    
    /// Adds a `UIViewController` instance to the tab bar controller.
    ///
    /// - parameter viewController: The view controller to add.
    open func add(_ viewController: UIViewController) {
        self.viewControllers.append(viewController)
        self.updateTabBarItems()
        
        if viewController is UINavigationController, let navigationController = viewController as? UINavigationController {
            navigationController.delegate = self
        }
        
        self.updateContentInset(viewController: viewController)
        
        if let viewController = self.viewControllers.first {
            self.show(viewController)
        }
    }
    
    /// Removes a `UIViewController` instance from the tab bar controller.
    ///
    /// - parameter viewController: The view controller to remove.
    open func remove(_ viewController: UIViewController) {
        if let idx = self.viewControllers.index(of: viewController) {
            self.viewControllers.remove(at: idx)
        }
        self.updateTabBarItems()
        
        if viewController is UINavigationController, let navigationController = viewController as? UINavigationController {
            navigationController.delegate = nil
        }
        
        if let viewController = self.viewControllers.first {
            self.show(viewController)
        }
    }
    
    /// Shows a `UIViewController` instance already conatined by tab bar controller.
    ///
    /// - parameter viewController: The view controller to show.
    open func show(_ viewController: UIViewController) {
        if self.pageViewController.viewControllers?.first == nil || self.pageViewController.viewControllers!.first! != viewController {
            var direction = UIPageViewControllerNavigationDirection.forward
            let idx = self.viewControllers.index(of: viewController)!
            
            if let vc = self.pageViewController.viewControllers?.first, let prevIdx = self.viewControllers.index(of: vc), prevIdx > idx {
                direction = .reverse
            }
            
            self.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
            self.tabBar.selectedItem = self.tabBar.items![idx]
        }
    }
    
    /// Iterates over the current child view controllers and adds their `UITabBarItem`s to the tab bar.
    private func updateTabBarItems() {
        var items = [UITabBarItem]()
        
        for viewController in self.viewControllers {
            items.append(viewController.tabBarItem)
        }
        
        self.tabBar.setItems(items, animated: true)
    }
    
    /// If the supplied view controller's view is a `UIScrollView` instance,
    /// update its content inset to match the tab bar height.
    ///
    /// - parameter viewController: The view controller instance to update.
    private func updateContentInset(viewController: UIViewController) {
        func setContentInset(scrollView: UIScrollView) {
            let inset = self.view.traitCollection.verticalSizeClass == .compact ? Config.HorizontalHeight : Config.VerticalHeight
            
            var contentInset = scrollView.contentInset
            contentInset.bottom = inset
            scrollView.contentInset = contentInset
            
            var scrollInset = scrollView.scrollIndicatorInsets
            scrollInset.bottom = inset
            scrollView.scrollIndicatorInsets = scrollInset
        }
        
        var rootViewController: UIViewController!
        if viewController is UINavigationController {
            rootViewController = (viewController as! UINavigationController).topViewController
        } else {
            rootViewController = viewController
        }
        
        if let scrollView = rootViewController.view as? UIScrollView {
            setContentInset(scrollView: scrollView)
        } else if let scrollView = rootViewController.view.subviews.first as? UIScrollView {
            setContentInset(scrollView: scrollView)
        }
    }
}

/// Extend `TabBarPageController` to conform to `UIPageViewController` delegate protocols.
extension TabBarPageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Page View Controller Data Source
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = 0
        
        if let i = self.viewControllers.index(of: viewController) {
            if i == 0 {
                index = self.viewControllers.count - 1
            } else {
                index = i - 1
            }
        }
        
        return self.viewControllers[index]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = 0
        
        if let i = self.viewControllers.index(of: viewController) {
            if i == self.viewControllers.count - 1 {
                index = 0
            } else {
                index = i + 1
            }
        }
        
        return self.viewControllers[index]
    }
    
    // MARK: - Page View Controller Delegate
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        
        if let viewController = pageViewController.viewControllers?.first {
            if let idx = self.viewControllers.index(of: viewController) {
                self.tabBar.selectedItem = self.tabBar.items![idx]
            }
        }
    }
}

/// Extends `TabBarPageController` to conform to the `UITabBarDelegate` and `UINavigationControllerDelegate` protocols.
extension TabBarPageController: UITabBarDelegate, UINavigationControllerDelegate {
    
    // MARK: - Tab Bar Delegate
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let idx = tabBar.items?.index(of: item) {
            self.show(self.viewControllers[idx])
        }
    }
    
    // MARK: - Navigation Controller Delegate
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.first != viewController {
            self.pageViewController.dataSource = nil
            updateTabBarOffset(self.tabBar.frame.size.height)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.first == viewController {
            self.pageViewController.dataSource = self
            updateTabBarOffset(0)
        }
    }
    
    /// Updates the tab bar's bottom constraint.
    func updateTabBarOffset(_ constant: CGFloat) {
        if self.tabBarBottomConstraint?.constant != constant {
            // We need to wrap the animation in a GCD block to avoid a crash bug
            // in `UIPageViewController` when animating to a new view controller.
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
                self.tabBarBottomConstraint?.constant = constant
                UIView.animate(withDuration: Config.AnimationDuration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}
