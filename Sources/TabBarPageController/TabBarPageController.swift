//
//  TabBarPageController.swift
//  TabBarPageController
//
//  Created by Conor Mulligan on 23/04/2018.
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
import OSLog

/// A container view controller that manages navigation between tabs of content.
/// Each tab is represented by a child view controller embedded in a `UIPageViewController` instance,
/// allowing users to navigate between tabs by either selecting the appropriate tab bar item or swiping left and right.
///
/// Create a `TabBarPageController` instance and add view controllers to it:
///
/// ```swift
/// let tabBarController = TabBarPageController()
/// tabBarController.addViewController(viewController)
/// ```
///
/// Show a specific view controller:
///
/// ```swift
/// tabBarController.showViewController(viewController)
/// ```
///
/// You can configure the appearance of tab bar items by changing the child view controllers' `UITabBarItem` values.
///
/// Note: although `TabBarPageController` is similar to `UITabBarController`, it's not a drop-in replacement and includes a number of important differences:
///
/// - `TabBarPageController` always hides the tab bar when a child navigation view controller pushes a new view controller.
/// This is to avoid interfering with the navigation controller's back navigation gesture.
/// - Editing and the "more" navigation controller are not supported.
open class TabBarPageController: UIViewController {

    /// Represents the `TabBarPageController` configuration.
    public struct Configuration {
        /// The inter-page spacing.
        public var pageSpacing: CGFloat = 10

        /// The tab bar vertical height when the vertical size class is regular.
        public var regularTabBarHeight: CGFloat = 50

        /// The tab bar height when the vertical size class is compact.
        public var compactTabBarHeight: CGFloat = 34

        /// The animation duration used when showing and hiding the tab bar.
        public var animationDuration: Double = 0.2

        public init() {

        }
    }

    // MARK: - Properties

    /// The configuration.
    public let configuration: Configuration

    /// The embedded page view controller.
    open private(set) lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: [.interPageSpacing: configuration.pageSpacing])
        viewController.dataSource = self
        viewController.delegate = self
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()

    /// The tab bar.
    open private(set) lazy var tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()

    override open var childForStatusBarStyle: UIViewController? {
        return pageViewController.viewControllers?.first
    }

    override open var childForStatusBarHidden: UIViewController? {
        return pageViewController.viewControllers?.first
    }

    /// A list of view controllers, each of which is represented by a tab.
    open private(set) var viewControllers = [UIViewController]()

    /// The tab bar's height constraint.
    internal var tabBarHeightConstraint: NSLayoutConstraint?

    /// The tab bar's bottom layout constraint.
    internal var tabBarBottomConstraint: NSLayoutConstraint?

    /// The log used when writing log messages.
    internal let log = OSLog(subsystem: "com.github.conmulligan.TabBarPageController", category: "TabBarPageController")

    // MARK: - Initialization

    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Add subviews.
        addChild(pageViewController)
        [pageViewController.view, tabBar].forEach { view.addSubview($0) }
        pageViewController.didMove(toParent: self)

        // Create tab bar constraints.
        tabBarHeightConstraint = tabBar.heightAnchor.constraint(equalToConstant: configuration.regularTabBarHeight)
        tabBarBottomConstraint = tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        // Activate layout constraints.
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarHeightConstraint!,
            tabBarBottomConstraint!
        ])
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Update the layout for the current trait collection.
        layoutFor(traitCollection: traitCollection)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNeedsStatusBarAppearanceUpdate()
    }

    override open func willTransition(to newCollection: UITraitCollection,
                                      with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        layoutFor(traitCollection: newCollection)
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for viewController in viewControllers {
            updateContentInset(viewController: viewController)
        }
    }

    override open func viewDidLayoutSubviews() {
        layoutFor(traitCollection: view.traitCollection)
    }

    /// Updates the view constraints based on the supplied trait collection.
    ///
    /// - Parameter traitCollection: The current trait collection.
    private func layoutFor(traitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass == .compact {
            tabBarHeightConstraint?.constant = configuration.compactTabBarHeight + view.safeAreaInsets.bottom
        } else {
            tabBarHeightConstraint?.constant = configuration.regularTabBarHeight + view.safeAreaInsets.bottom
        }
    }

    // MARK: - View Management

    /// Iterates over the current child view controllers and adds their `UITabBarItem`s to the tab bar.
    private func updateTabBarItems() {
        tabBar.setItems(viewControllers.map(\.tabBarItem), animated: true)
    }

    /// Updates the content inset for the supplied scroll view.
    ///
    /// - Parameter scrollView: The scroll view.
    private func updateContentInset(for scrollView: UIScrollView) {
        let inset = view.traitCollection.verticalSizeClass == .compact
            ? configuration.compactTabBarHeight
            : configuration.regularTabBarHeight

        var contentInset = scrollView.contentInset
        contentInset.bottom = inset
        scrollView.contentInset = contentInset

        var scrollInset = scrollView.verticalScrollIndicatorInsets
        scrollInset.bottom = inset
        scrollView.scrollIndicatorInsets = scrollInset
    }

    /// If the supplied view controller's view is a `UIScrollView` instance,
    /// update its content inset to match the tab bar height.
    ///
    /// - Parameter viewController: The view controller instance to update.
    private func updateContentInset(viewController: UIViewController) {
        let rootViewController: UIViewController

        if let navigationController = viewController as? UINavigationController,
           let topViewController = navigationController.topViewController {
            rootViewController = topViewController
        } else {
            rootViewController = viewController
        }

        if let scrollView = rootViewController.view as? UIScrollView {
            updateContentInset(for: scrollView)
        } else if let scrollView = rootViewController.view.subviews.first as? UIScrollView {
            updateContentInset(for: scrollView)
        }
    }
}

extension TabBarPageController {

    // MARK: - Child View Controllers

    open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool = true) {
        // Before replacing the existing view controllers,
        // ensure we any delegates have been nilled out.
        for viewController in self.viewControllers {
            if let navigationController = viewController as? UINavigationController {
                navigationController.delegate = nil
            }
        }

        // Set the view controllers and update the tab bar.
        self.viewControllers = viewControllers
        updateTabBarItems()

        for viewController in self.viewControllers {
            // If the view controller is an instance of `UINavigationController`,
            // become the navigation controller delegate.
            if let navigationController = viewController as? UINavigationController {
                navigationController.delegate = self
            }
        }

        if let viewController = viewControllers.first {
            showViewController(viewController)
        }
    }

    /// Adds a `UIViewController` instance to the tab bar controller.
    ///
    /// - Parameter viewController: The view controller to add.
    open func addViewController(_ viewController: UIViewController) {
        // Ensure that the view controller instance hasn't already been added.
        guard !viewControllers.contains(viewController) else {
            os_log("Warning: attempting to add a view controller that has already been added.", log: log, type: .info)
            return
        }

        // Add the view controller and update the tab bar.
        viewControllers.append(viewController)
        updateTabBarItems()
        updateContentInset(viewController: viewController)

        // If the view controller is an instance of `UINavigationController`,
        // become the navigation controller delegate.
        if let navigationController = viewController as? UINavigationController {
            navigationController.delegate = self
        }

        if let viewController = viewControllers.first {
            showViewController(viewController)
        }
    }

    /// Removes a `UIViewController` instance from the tab bar controller.
    ///
    /// - Parameter viewController: The view controller to remove.
    open func removeViewController(_ viewController: UIViewController) {
        if let index = viewControllers.firstIndex(of: viewController) {
            self.viewControllers.remove(at: index)
        }
        updateTabBarItems()

        if let navigationController = viewController as? UINavigationController {
            navigationController.delegate = nil
        }

        if let viewController = viewControllers.first {
            showViewController(viewController)
        }
    }

    /// Shows a `UIViewController` instance already contained by the tab bar controller.
    ///
    /// - Parameter viewController: The view controller to show.
    open func showViewController(_ viewController: UIViewController, animated: Bool = true) {
        let firstViewController = pageViewController.viewControllers?.first

        if firstViewController == nil || firstViewController != viewController {
            var direction = UIPageViewController.NavigationDirection.forward
            let index = viewControllers.firstIndex(of: viewController)!

            if let viewController = pageViewController.viewControllers?.first,
               let previousIndex = viewControllers.firstIndex(of: viewController),
               previousIndex > index {
                direction = .reverse
            }

            pageViewController.setViewControllers([viewController], direction: direction, animated: animated)
            tabBar.selectedItem = tabBar.items![index]
        }

        self.setNeedsStatusBarAppearanceUpdate()
    }
}

extension TabBarPageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Page View Controller Data Source

    open func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = 0

        if let i = viewControllers.firstIndex(of: viewController) {
            if i == 0 {
                index = viewControllers.count - 1
            } else {
                index = i - 1
            }
        }

        return viewControllers[index]
    }

    open func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = 0

        if let i = viewControllers.firstIndex(of: viewController) {
            if i == viewControllers.count - 1 {
                index = 0
            } else {
                index = i + 1
            }
        }

        return viewControllers[index]
    }

    // MARK: - Page View Controller Delegate

    open func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let viewController = pageViewController.viewControllers?.first else { return }
        guard let index = viewControllers.firstIndex(of: viewController) else { return }

        tabBar.selectedItem = tabBar.items![index]
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension TabBarPageController: UITabBarDelegate, UINavigationControllerDelegate {

    // MARK: - Tab Bar Delegate

    open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        showViewController(viewControllers[index])
    }

    // MARK: - Navigation Controller Delegate

    open func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                     animated: Bool) {
        if navigationController.viewControllers.first != viewController {
            disableScrolling()
            updateTabBarOffset(tabBar.frame.size.height)
        }

        setNeedsStatusBarAppearanceUpdate()
    }

    open func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        if navigationController.viewControllers.first == viewController {
            enableScrolling()
            updateTabBarOffset(0)
        }

        setNeedsStatusBarAppearanceUpdate()
    }

    /// Updates the tab bar's bottom constraint.
    ///
    /// - Parameter constant: The new bottom constraint constant.
    private func updateTabBarOffset(_ constant: CGFloat) {
        guard tabBarBottomConstraint?.constant != constant else { return }

        view.layoutIfNeeded()

        tabBarBottomConstraint?.constant = constant

        UIView.animate(withDuration: configuration.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    /// Disables scrolling on the page controller's internal scroll view.
    private func disableScrolling() {
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
    }

    /// Enables scrolling on the page controller's internal scroll view.
    private func enableScrolling() {
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = true
            }
        }
    }
}
