//
//  ViewController.swift
//  TabBarPageController
//
//  Created by Conor Mulligan on 04/25/2018.
//  Copyright (c) 2018 conmulligan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Navigation Controller"
        self.view.backgroundColor = .white
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        button.setTitle("Push View Controller", for: UIControlState())
        button.setTitleColor(self.view.tintColor, for: UIControlState())
        button.center = self.view.center
        button.addTarget(self, action: #selector(pushViewController(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func pushViewController(_ sender: AnyObject?) {
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
