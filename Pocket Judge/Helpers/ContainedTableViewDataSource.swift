//
//  ContainedTableViewDataSource.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit
import RealmSwift


class ContainedTableViewDataSourceList<T: Object>: NSObject, UITableViewDataSource {
    //    var items: [T]
    var items: List<T>
    let cellIdentifier: String
    let cellConfigurationHandler:(NSIndexPath, UITableViewCell, T) -> UITableViewCell
    
    init(items: List<T>, cellIdentifier: String, cellConfigurationHandler: (NSIndexPath,UITableViewCell, T) -> UITableViewCell) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellConfigurationHandler = cellConfigurationHandler
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let item = itemAtIndexPath(indexPath)
        return cellConfigurationHandler(indexPath,tableViewCell, item)
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> T {
        return items[indexPath.row]
    }
}

class ContainedTableViewDataSourceResults<T: Object>: NSObject, UITableViewDataSource {
//    var items: [T]
    var items: Results<T>
    let cellIdentifier: String
    let cellConfigurationHandler:(NSIndexPath, UITableViewCell, T) -> UITableViewCell
    
    init(items: Results<T>, cellIdentifier: String, cellConfigurationHandler: (NSIndexPath, UITableViewCell, T) -> UITableViewCell) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellConfigurationHandler = cellConfigurationHandler
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let item = itemAtIndexPath(indexPath)
        return cellConfigurationHandler(indexPath, tableViewCell, item)
        
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> T {
        return items[indexPath.row]
    }
}
