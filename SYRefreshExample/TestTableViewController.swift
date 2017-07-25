//
//  TestTableViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {

    var count  = 15
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(60, 0, 100, 0)
        tableView.sy_header = TextHeaderFooter(normalText: VerticalHintText.headerNomalText, pullingText: VerticalHintText.headerPullingText, refreshingText: VerticalHintText.headerRefreshText,nomoreDataText:nil, orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.tableView.sy_header?.endRefreshing()
                self?.count = 15
                self?.tableView.reloadData()
            }
        })
        
        tableView.sy_footer = TextHeaderFooter(normalText: VerticalHintText.footerNomalText, pullingText: VerticalHintText.footerPullingText, refreshingText: VerticalHintText.footerRefreshText, nomoreDataText:"没有更多数据了",orientation: .bottom, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if (self?.count)! >= 50 {
                    self?.tableView.sy_footer?.noMoreData()
                }else{
                    self?.count += 0
                    self?.tableView.sy_footer?.endRefreshing()
                }
                self?.tableView.reloadData()
            }
        })
        
        tableView.sy_header?.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "indepath==\(indexPath.row)"
        return cell
    }

}
