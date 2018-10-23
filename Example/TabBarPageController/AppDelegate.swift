//
//  AppDelegate.swift
//  TabBarPageController
//
//  Created by Conor Mulligan on 25/04/2018.
//  Copyright © 2018 Conor Mulligan. All rights reserved.
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let viewControllerBounds = 2...8
    
    var window: UIWindow?

    lazy var tabBarController = TabBarPageController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .black
        
        self.window?.rootViewController = self.tabBarController
        
        // Add two view controllers.
        self.addViewController()
        self.addViewController()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    // MARK: - View Controllers
    
    func initializeNavigationViewController() -> UINavigationController {
        let viewController = ViewController()
        viewController.appDelegate = self
        viewController.title = NSLocalizedString("Navigation Controller", comment: "")
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: "Circle")
        return navigationController
    }
 
    func initializeTableViewController() -> TableViewController {
        let tableViewController = TableViewController()
        tableViewController.appDelegate = self
        tableViewController.title = NSLocalizedString("Table View Controller", comment: "")
        tableViewController.tabBarItem.image = UIImage(named: "Triangle")
        return tableViewController
    }
    
    func addViewController() {
        if self.tabBarController.viewControllers.count % 2 == 0 {
            let navigationController = self.initializeNavigationViewController()
            navigationController.tabBarItem.title = "\(self.tabBarController.viewControllers.count + 1)"
            self.tabBarController.add(navigationController)
        } else {
            let viewController = self.initializeTableViewController()
            viewController.tabBarItem.title = "\(self.tabBarController.viewControllers.count + 1)"
            self.tabBarController.add(viewController)
        }
    }
    
    func removeViewController() {
        guard self.tabBarController.viewControllers.count > AppDelegate.viewControllerBounds.lowerBound else {
            return
        }
        
        if let vc = self.tabBarController.viewControllers.last {
            self.tabBarController.remove(vc)
        }
    }
}
