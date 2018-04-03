//
//  CoreTextTableViewController.swift
//  SYRefreshExampleforSwift
//
//  Created by shusy on 2017/6/16.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class CoreTextTableViewController: UITableViewController {

    var count  = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        
        let textItem = TextItem(normalText: "要减脂，找变啦", pullingText: "松开手减脂一触即达", refreshingText: "正在为您推荐减脂产品", nomoreDataText: nil, font: UIFont.systemFont(ofSize: 18), color: UIColor.green)

        tableView.sy_header = CoreTextHeaderFooter(textItem: textItem, orientation: .top, height: 44,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self?.tableView.sy_header?.endRefreshing()
                self?.count = 50
                self?.tableView.reloadData()
            }
        })
        
        let textItem1 = TextItem(normalText: VerticalHintText.headerNomalText, pullingText: VerticalHintText.headerPullingText, refreshingText: VerticalHintText.headerRefreshText, nomoreDataText:"没有更多数据",font: UIFont.systemFont(ofSize: 18), color: UIColor.green)

        tableView.sy_footer = CoreTextHeaderFooter(textItem: textItem1, orientation: .bottom, height: 44,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self?.tableView.sy_footer?.endRefreshing()
                self?.count += 15
                self?.tableView.reloadData()
            }
        })
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
    
    deinit {
        print("deinit ===\(self)")
    }


}
