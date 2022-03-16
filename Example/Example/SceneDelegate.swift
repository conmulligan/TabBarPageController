//
//  SceneDelegate.swift
//  TabBarPageControllerExample
//
//  Created by Conor Mulligan on 12/03/2022.
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
import TabBarPageController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// The main window.
    var window: UIWindow?

    /// The tab bar page controller.
    var tabBarPageController: TabBarPageController?

    // MARK: - Scene Delegate

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let firstViewController = makeViewController(title: NSLocalizedString("First", comment: ""),
                                                     tabBarItemImage: UIImage(systemName: "circle.fill"))
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)

        let secondViewController = makeViewController(title: NSLocalizedString("Second", comment: ""),
                                                      tabBarItemImage: UIImage(systemName: "rectangle.fill"))
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)

        let thirdViewController = makeViewController(title: NSLocalizedString("Third", comment: ""),
                                                     tabBarItemImage: UIImage(systemName: "triangle.fill"))
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)

        // Create the tab bar page controller.
        var configuration = TabBarPageController.Configuration()
        configuration.pageSpacing = 5
        tabBarPageController = TabBarPageController(configuration: configuration)

        // Set view controllers.
        tabBarPageController?.setViewControllers([
            firstNavigationController, secondNavigationController, thirdNavigationController
        ], animated: true)

        // Initialize the window and make it visible.
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarPageController
        window?.tintColor = .systemPink
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough
        // scene-specific state information to restore the scene back to its current state.
    }
}

extension SceneDelegate {

    // MARK: - View Controllers

    private func makeViewController(title: String?, tabBarItemImage: UIImage?) -> UIViewController {
        let viewController = ViewController()
        viewController.title = title
        viewController.tabBarItem.image = tabBarItemImage

        let removeAction = UIAction { [weak self] _ in
            self?.removeLastViewController()
        }
        let removeItem = UIBarButtonItem(title: NSLocalizedString("Remove", comment: ""),
                                         image: UIImage(systemName: "minus"),
                                         primaryAction: removeAction,
                                         menu: nil)

        let addAction = UIAction { [weak self] _ in
            self?.addNewViewController()
        }
        let addItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""),
                                      image: UIImage(systemName: "plus"),
                                      primaryAction: addAction,
                                      menu: nil)

        viewController.navigationItem.leftBarButtonItem = removeItem
        viewController.navigationItem.rightBarButtonItem = addItem

        return viewController
    }

    private func removeLastViewController() {
        guard let tabBarPageController = tabBarPageController else { return }
        guard tabBarPageController.viewControllers.count > 1 else { return }
        guard let viewController = tabBarPageController.viewControllers.last else { return }

        tabBarPageController.removeViewController(viewController)
    }

    private func addNewViewController() {
        let viewController = makeViewController(title: NSLocalizedString("New", comment: ""),
                                                tabBarItemImage: UIImage(systemName: "star.fill"))
        let navigationController = UINavigationController(rootViewController: viewController)
        tabBarPageController?.addViewController(navigationController)
    }
}
