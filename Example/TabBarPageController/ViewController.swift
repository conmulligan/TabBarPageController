//
//  ViewController.swift
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

class ViewController: UIViewController {

    var appDelegate: AppDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Minus"),
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(removeViewController(_:)))

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Plus"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(addViewController(_:)))
        }
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        button.setTitle(NSLocalizedString("Push View Controller", comment: ""), for: UIControlState())
        button.setTitleColor(self.view.tintColor, for: UIControlState())
        button.center = self.view.center
        button.addTarget(self, action: #selector(pushViewController(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toggleBarButtonItems()
        
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.navigationBar.barStyle = .black
        } else {
            self.navigationController?.navigationBar.barStyle = .default
        }
    }
    
    // MARK: - Actions
    
    @objc func removeViewController(_ sender: AnyObject?) {
        self.appDelegate?.removeViewController()
        self.toggleBarButtonItems()
    }
    
    @objc func addViewController(_ sender: AnyObject?) {
        self.appDelegate?.addViewController()
        self.toggleBarButtonItems()
    }
    
    @objc func pushViewController(_ sender: AnyObject?) {
        let viewController = ViewController()
        viewController.appDelegate = self.appDelegate
        viewController.title = NSLocalizedString("Navigation Controller", comment: "")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - UI
    
    private func toggleBarButtonItems() {
        guard let count = self.appDelegate?.tabBarController.viewControllers.count else { return }
        
        self.navigationItem.leftBarButtonItem?.isEnabled = (count > AppDelegate.viewControllerBounds.lowerBound)
        self.navigationItem.rightBarButtonItem?.isEnabled = (count < AppDelegate.viewControllerBounds.upperBound)
    }
}
