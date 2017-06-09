//
//  TestTableViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        
        tableView.sy_header = RefreshTextHeader(normalText: RefreshConfig.headerNomalText, pullingText: RefreshConfig.headerPullingText, refreshingText: RefreshConfig.headerRefreshText, orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.tableView.sy_header?.endRefreshing()
            }
        })
        
        
        tableView.sy_footer = RefreshTextHeader(normalText: RefreshConfig.footerNomalText, pullingText: RefreshConfig.footerPullingText, refreshingText: RefreshConfig.footerRefreshText, orientation: .bottom, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.tableView.sy_footer?.endRefreshing()
            }
        })
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "indepath==\(indexPath.row)"
        return cell
    }

}
