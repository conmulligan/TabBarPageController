//
//  AppDelegate.swift
//  TabBarPageController
//
//  Created by Conor Mulligan on 04/25/2018.
//  Copyright (c) 2018 conmulligan. All rights reserved.
//

import UIKit
import TabBarPageController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .black
        
        let tabBarController = TabBarPageController()
        self.window?.rootViewController = tabBarController
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: "Circle")
        tabBarController.add(navigationController)

        let tableViewController = TableViewController()
        tableViewController.tabBarItem.image = UIImage(named: "Triangle")
        tabBarController.add(tableViewController)
        
        tabBarController.show(tableViewController)
        
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
}
