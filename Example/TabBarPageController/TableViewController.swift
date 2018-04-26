//
//  TableViewController.swift
//  TabBarPageController
//
//  Created by Conor Mulligan on 25/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Table View"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = "Cell \(indexPath.row)"
        
        return cell
    }
}
